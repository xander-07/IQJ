package database

import (
	"database/sql"
	"errors"
	"fmt"
	"log"

	"golang.org/x/crypto/bcrypt"
)

// User представляет сущность пользователя в системе.
type User struct {
	Id       int64  `json:"id"`       // Уникальный идентификатор пользователя
	Email    string `json:"email"`    // Электронная почта пользователя
	Password string `json:"password"` // Хешированный пароль пользователя
}

// isDefault проверяет, переданы ли какие-либо данные в структуру User.
// Необходимо для реализации интерфейса Entity и фильтров в функциях БД.
func (u *User) isDefault() bool {
	return u.Id == 0 && u.Email == "" && u.Password == ""
}

// UserTable предоставляет методы для работы с таблицей пользователей в базе данных.
type UserTable struct {
	db *sql.DB          // Указатель на подключение к базе данных
	tm transactionMaker // Создатель транзакций
}

// ВНИМАНИЕ!
//
//	Данная функция устарела и скоро будет удалена, используйте User.AddNew!
//
// ВНИМАНИЕ!
//
// Add добавляет пользователя в базу данных.
// Принимает указатель на User с заполненными полями.
// Возвращает nil при успешном добавлении.
//
// Прим:
// user := &User{Email: "example@example.com", Password: "example"}
// err := ...Add(user) // err == nil если все хорошо
func (ut *UserTable) Add(u *User) (*User, error) {
	if u.isDefault() {
		return nil, errors.New("User.Add: wrong data! provided *User is empty")
	}

	// Используем базовую функцию для создания и исполнения insert запроса
	row, err := ut.tm.makeInsert(ut.db,
		"INSERT INTO users (email,password) VALUES ($1, $2) RETURNING user_id",
		u.Email, u.Password,
	)

	if err != nil {
		return nil, fmt.Errorf("User.Add: %v", err)
	}

	// Получаем идентификатор пользователя из результата вставки
	if err := row.Scan(&u.Id); err != nil {
		return nil, fmt.Errorf("User.Add: error scanning user_id: %v", err)
	}

	return u, nil
}

func (ut *UserTable) AddNew(u *User) (*User, error) {
	if u.isDefault() {
		return nil, errors.New("User.Add: wrong data! provided *User is empty")
	}

	// Начинаем транзакцию
	tx, err := ut.db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	// Выполняем запрос INSERT внутри транзакции
	var userId int
	err = tx.QueryRow(
		"INSERT INTO users (email, password) VALUES ($1, $2) RETURNING user_id",
		u.Email, u.Password,
	).Scan(&userId)
	if err != nil {
		return nil, fmt.Errorf("User.Add: error executing INSERT query: %v", err)
	}

	// Коммитим транзакцию
	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("User.Add: error committing transaction: %v", err)
	}

	u.Id = int64(userId)

	return u, nil
}

// GetById возвращает данные пользователя из базы данных по указанному идентификатору.
// Принимает указатель на User с заполненным полем Id.
// Возвращает заполненную структуру User и nil при успешном запросе.
//
// Прим:
// user := &User{Id: 1}
// user, err := ...GetById(user) // err == nil если все хорошо
func (ut *UserTable) GetById(u *User) (*User, error) {
	// Проверяем переданы ли данные в функцию
	if u.isDefault() {
		return nil, errors.New("User.Get: wrong data! provided *User is empty")
	}
	// Проверяем передан ли id
	if u.Id == 0 {
		return nil, errors.New("User.Get: wrong data! provided *User.Id is empty")
	}

	rows, err := ut.tm.makeSelect(ut.db, "SELECT email, password FROM users WHERE user_id = $1", u.Id)
	if err != nil {
		return nil, fmt.Errorf("User.Get: %v", err)
	}
	defer rows.Close()
	// Сканируем данные из результата запроса и заполняем структуру User
	if rows.Next() {
		if err := rows.Scan(&u.Email, &u.Password); err != nil {
			return nil, err
		}
	} else {
		return nil, errors.New("User.Get: no rows returned")
	}

	return u, nil
}

// Check проверяет наличие пользователя в базе данных и соответствие введенного пароля.
// Принимает указатель на User с заполненными полями Email и Password.
// Возвращает заполненную структуру User и nil при успешном запросе.
//
// Прим:
// user := &User{Email: "example@example.com", Password: "example"}
// user, err := ...Check(user) // err == nil если все хорошо
func (ut *UserTable) Check(u *User) (*User, error) {
	// Проверяем переданы ли данные в функцию
	if u.isDefault() {
		return nil, errors.New("User.Check: wrong data! *User is empty")
	}

	// Переменные, в которых мы будем хранить полученные данные из базы данных
	id := 0
	pass := ""

	rows, err := ut.tm.makeSelect(ut.db, "SELECT password, user_id FROM users WHERE email = $1", u.Email)
	if err != nil {
		return nil, fmt.Errorf("User.Check1: %v", err)
	}
	defer func() {
		if err := rows.Close(); err != nil {
			log.Printf("Error closing rows: %v", err)
		}
	}()

	if rows.Next() {
		if err := rows.Scan(&pass, &id); err != nil {
			return nil, fmt.Errorf("User.Check: %v", err)
		}
	} else {
		return nil, errors.New("User not found")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(pass), []byte(u.Password)); err != nil {
		return nil, errors.New("Users.Check: incorrect password!")
	}
	// Если все хорошо, возвращаем пользователя с id
	u.Id = int64(id)
	return u, nil
}

// Delete удаляет данные пользователя из базы данных по указанному идентификатору.
// Принимает указатель на User с заполненным полем Id.
// Возвращает nil при успешном удалении.
//
// Прим:
// user := &User{Id: 1}
// err := ...Delete(user) // err == nil если все хорошо
func (ut *UserTable) Delete(u *User) error {
	// Проверяем дали ли нам нужные данные
	if u.isDefault() {
		return errors.New("User.Delete: wrong data! *User.Id is empty")
	}

	// Для удаления используем базовую функцию
	err := ut.tm.makeDelete(ut.db, "DELETE FROM users WHERE user_id = $1", u.Id)

	if err != nil {
		return fmt.Errorf("User.Delete: %v", err)
	}

	return nil
}
