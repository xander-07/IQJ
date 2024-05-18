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
	db *sql.DB // Указатель на подключение к базе данных
}

// Add добавляет данные пользователя в базу данных.
func (udt *UserDataTable) Add(ud UserData) error {
	if ud.isDefault() {
		return errors.New("UserData.Add: wrong data! provided *UserData is empty")
	}

	tx, err := udt.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.Exec(
		"INSERT INTO users_data (user_data_id, user_name, biography, useful_data, role) VALUES ($1, $2, $3, $4, $5)",
		ud.Id, ud.Name, ud.Bio, ud.UsefulData, ud.Role,
	)
	if err != nil {
		return fmt.Errorf("UserData.Add: %v", err)
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("UserData.Add: error committing transaction: %v", err)
	}

	return nil
}

// GetById возвращает данные пользователя из базы данных по указанному идентификатору.
func (udt *UserDataTable) GetById(ud UserData) (*UserData, error) {
	if ud.isDefault() {
		return nil, errors.New("UserData.GetById: wrong data! provided *UserData is empty")
	}
	if ud.Id == 0 {
		return nil, errors.New("UserData.GetById: wrong data! provided *UserData.Id is empty")
	}

	tx, err := udt.db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRow("SELECT user_name, biography, useful_data, role FROM users_data WHERE user_data_id = $1 AND NOT user_data_is_deleted", ud.Id)
	if row.Err() != nil {
		return nil, fmt.Errorf("UserData.GetById: %v", err)
	}

	err = row.Scan(&ud.Name, &ud.Bio, &ud.UsefulData, &ud.Role)
	if err != nil {
		return nil, err
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("UserData.GetById: error committing transaction: %v", err)
	}

	return &ud, nil
}

// GetByName возвращает данные пользователя из базы данных по указанному имени.
func (udt *UserDataTable) GetByName(ud UserData) (*UserData, error) {
	if ud.Name == "" {
		return nil, errors.New("UserData.GetByName: wrong data! provided *UserData.Name is empty")
	}

	tx, err := udt.db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRow("SELECT user_data_id, biography, useful_data, role FROM users_data WHERE user_name = $1 AND NOT user_data_is_deleted", ud.Name)
	if row.Err() != nil {
		return nil, fmt.Errorf("UserData.GetByName: %v", row.Err().Error())
	}

	err = row.Scan(&ud.Id, &ud.Bio, &ud.UsefulData, &ud.Role)
	if err != nil {
		return nil, err
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("UserData.GetByName: error committing transaction: %v", err)
	}

	return &ud, nil
}

// GetRoleById возвращает роль пользователя из базы данных по указанному идентификатору.
func (udt *UserDataTable) GetRoleById(ud UserData) (*UserData, error) {
	if ud.Id == 0 {
		return nil, errors.New("UserData.GetRoleById: wrong data! provided *UserData.Id is empty")
	}

	tx, err := udt.db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRow("SELECT role FROM users_data WHERE user_data_id = $1 AND NOT user_data_is_deleted", ud.Id)
	if row.Err() != nil {
		return nil, fmt.Errorf("UserData.GetRoleById: %v", row.Err().Error())
	}

	err = row.Scan(&ud.Role)
	if err != nil {
		return nil, err
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("UserData.GetRoleById: error committing transaction: %v", err)
	}

	return &ud, nil
}

// Update обновляет данные пользователя в базе данных.
func (udt *UserDataTable) Update(userData UserData) error {
	if userData.Id <= 0 {
		return errors.New("UserData.Update: userData.Id must be a positive integer")
	}

	tx, err := udt.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.Exec(
		"UPDATE users_data SET user_name = $1, biography = $2, useful_data = $3, role = $4 WHERE user_data_id = $5 AND NOT user_data_is_deleted",
		userData.Name, userData.Bio, userData.UsefulData, userData.Role, userData.Id)
	if err != nil {
		return fmt.Errorf("UserData.Update: %v", err)
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("UserData.Update: error committing transaction: %v", err)
	}

	return nil
}

// UpdateRole обновляет роль пользователя в базе данных по указанному идентификатору.
func (udt *UserDataTable) UpdateRole(userData UserData) error {
	if userData.Id <= 0 {
		return errors.New("UserData.UpdateRole: id must be a positive integer")
	}

	tx, err := udt.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.Exec(
		"UPDATE users_data SET role = $1 WHERE user_data_id = $2 AND NOT user_data_is_deleted",
		userData.Role, userData.Id)
	if err != nil {
		return fmt.Errorf("UserData.UpdateRole: %v", err)
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("UserData.UpdateRole: error committing transaction: %v", err)
	}

	return nil
}

// Delete удаляет данные пользователя из базы данных по указанному идентификатору.
func (udt *UserDataTable) Delete(ud UserData) error {
	if ud.Id == 0 {
		return errors.New("UserData.Delete: wrong data! *UserData.Id is empty")
	}

	tx, err := udt.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.Exec(`UPDATE users_data
	SET user_data_is_deleted = TRUE
	WHERE user_data_id = $1;`, ud.Id)
	if err != nil {
		return fmt.Errorf("UserData.Delete: %v", err)
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("UserData.Delete: error committing transaction: %v", err)
	}

	return nil
}

func newUserDataTable(db *sql.DB, query string) (*UserDataTable, error) {
	_, err := db.Exec(query)
	if err != nil {
		return nil, fmt.Errorf("failed to create users_data table: %v", err)
	}

	return &UserDataTable{db: db}, nil
}
