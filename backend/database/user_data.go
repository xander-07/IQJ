package database

import (
	"database/sql"
	"errors"
	"fmt"
)

// UserData представляет сущность данных о пользователе в системе.
type UserData struct {
	Id         int64  `json:"id"`          // Уникальный идентификатор данных пользователя
	Name       string `json:"name"`        // Имя пользователя
	Bio        string `json:"bio"`         // Биография пользователя
	UsefulData string `json:"useful_data"` // Дополнительные данные пользователя
	Role       string `json:"role"`        // Роль пользователя в системе
}

// isDefault проверяет, переданы ли какие-либо данные в структуру UserData.
// Необходимо для реализации интерфейса Entity и фильтров в функциях БД.
func (ud *UserData) isDefault() bool {
	return ud.Id == 0 && ud.Name == "" && ud.Bio == "" && ud.UsefulData == "" && ud.Role == ""
}

// UserDataTable предоставляет методы для работы с таблицей users_data в базе данных.
type UserDataTable struct {
	db *sql.DB          // Указатель на подключение к базе данных
	tm transactionMaker // Создатель транзакций
}

// Add добавляет данные пользователя в базу данных.
// Принимает указатель на UserData с заполненными полями.
// Возвращает nil при успешном добавлении.
//
// Прим:
// userData := &UserData{Name: "John", Bio: "Example bio", UsefulData: "Additional data", Role: "user"}
// err := ...Add(userData) // err == nil если все хорошо
func (udt *UserDataTable) Add(ud *UserData) error {

	// Проверяем были ли переданы данные в ud
	if ud.isDefault() {
		return errors.New("UserData.Add: wrong data! provided *UserData is empty")
	}

	// Используем базовую функцию для создания и исполнения insert запроса
	_, err := udt.tm.makeInsert(udt.db,
		"INSERT INTO users_data (user_data_id,user_name,biography,useful_data,role) VALUES ($1, $2, $3, $4, $5)",
		ud.Id, ud.Name, ud.Bio, ud.UsefulData, ud.Role,
	)

	if err != nil {
		return fmt.Errorf("UserData.Add: %v", err)
	}

	return nil
}

// GetById возвращает данные пользователя из базы данных по указанному идентификатору.
// Принимает указатель на UserData с заполненным полем Id.
// Возвращает заполненную структуру UserData и nil при успешном запросе.
//
// Прим:
// userData := &UserData{Id: 1}
// userData, err := ...GetById(userData) // err == nil если все хорошо
func (udt *UserDataTable) GetById(ud *UserData) (*UserData, error) {
	// Проверяем переданы ли данные в функцию
	if ud.isDefault() {
		return nil, errors.New("UserData.GetById: wrong data! provided *UserData is empty")
	}
	// Проверяем передан ли id
	if ud.Id == 0 {
		return nil, errors.New("UserData.GetById: wrong data! provided *UserData.Id is empty")
	}

	rows, err := udt.tm.makeSelect(udt.db,
		"SELECT name, bio, useful_data, role FROM users_data WHERE user_data_id = $1",
		ud.Id)
	if err != nil {
		return nil, fmt.Errorf("UserData.GetById: %v", err)
	}
	defer rows.Close()
	// Сканируем данные из результата запроса и заполняем структуру UserData
	if rows.Next() {
		if err := rows.Scan(&ud.Name, &ud.Bio, &ud.UsefulData, &ud.Role); err != nil {
			return nil, err
		}
	} else {
		return nil, errors.New("UserData.GetById: no rows returned")
	}

	return ud, nil
}

// GetByName возвращает данные пользователя из базы данных по указанному имени.
// Принимает указатель на UserData с заполненным полем Name.
// Возвращает заполненную структуру UserData и nil при успешном запросе.
//
// Прим:
// userData := &UserData{Name: "John"}
// userData, err := ...GetByName(userData) // err == nil если все хорошо
func (udt *UserDataTable) GetByName(ud *UserData) (*UserData, error) {
	// Проверяем передано ли имя пользователя
	if ud.Name == "" {
		return nil, errors.New("UserData.GetByName: wrong data! provided *UserData.Name is empty")
	}

	rows, err := udt.tm.makeSelect(udt.db,
		"SELECT user_data_id, bio, useful_data, role FROM users_data WHERE user_name = $1",
		ud.Name)
	if err != nil {
		return nil, fmt.Errorf("UserData.GetByName: %v", err)
	}
	defer rows.Close()
	// Сканируем данные из результата запроса и заполняем структуру UserData
	if rows.Next() {
		if err := rows.Scan(&ud.Id, &ud.Bio, &ud.UsefulData, &ud.Role); err != nil {
			return nil, err
		}
	} else {
		return nil, errors.New("UserData.GetByName: no rows returned")
	}

	return ud, nil
}

// GetRoleById возвращает роль пользователя из базы данных по указанному идентификатору.
// Принимает указатель на UserData с заполненным полем Id.
// Возвращает заполненную структуру UserData и nil при успешном запросе.
//
// Прим:
// userData := &UserData{Id: 1}
// userData, err := ...GetRoleById(userData) // err == nil если все хорошо
func (udt *UserDataTable) GetRoleById(ud *UserData) (*UserData, error) {
	// Проверяем передан ли id
	if ud.Id == 0 {
		return nil, errors.New("UserData.GetRoleById: wrong data! provided *UserData.Id is empty")
	}

	rows, err := udt.tm.makeSelect(udt.db,
		"SELECT role FROM users_data WHERE user_data_id = $1",
		ud.Id)
	if err != nil {
		return nil, fmt.Errorf("UserData.GetRoleById: %v", err)
	}
	defer rows.Close()
	// Сканируем данные из результата запроса и заполняем структуру UserData
	if rows.Next() {
		if err := rows.Scan(&ud.Role); err != nil {
			return nil, err
		}
	} else {
		return nil, errors.New("UserData.GetRoleById: no rows returned")
	}

	return ud, nil
}

func (udt *UserDataTable) Update(userData *UserData) error {
	if userData.Id <= 0 {
		return errors.New("UserData.Update: userData.Id must be a positive integer")
	}

	err := udt.tm.makeUpdate(udt.db,
		"UPDATE users_data SET user_name = $1, biography = $2, useful_data = $3, role = $4 WHERE user_data_id = $5",
		userData.Name, userData.Bio, userData.UsefulData, userData.Role, userData.Id)
	if err != nil {
		return fmt.Errorf("UserData.Update: %v", err)
	}

	return nil
}

func (udt *UserDataTable) UpdateRole(userData *UserData) error {
	if userData.Id <= 0 {
		return errors.New("UserData.UpdateRole: id must be a positive integer")
	}

	err := udt.tm.makeUpdate(udt.db,
		"UPDATE users_data SET role = $1 WHERE user_data_id = $2",
		userData.Id, userData.Role)
	if err != nil {
		return fmt.Errorf("UserData.UpdateRole: %v", err)
	}

	return nil
}

// Delete удаляет данные пользователя из базы данных по указанному идентификатору.
// Принимает указатель на UserData с заполненным полем Id.
// Возвращает nil при успешном удалении.
//
// Прим:
// userData := &UserData{Id: 1}
// err := ...Delete(userData) // err == nil если все хорошо
func (udt *UserDataTable) Delete(ud *UserData) error {
	// Проверяем дали ли нам нужные данные
	if ud.Id == 0 {
		return errors.New("UserData.Delete: wrong data! *UserData.Id is empty")
	}

	// Для удаления используем базовую функцию
	err := udt.tm.makeDelete(udt.db,
		"DELETE FROM users_data WHERE user_data_id = $1",
		ud.Id)

	if err != nil {
		return fmt.Errorf("UserData.Delete: %v", err)
	}

	return nil
}
