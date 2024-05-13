package database

import (
	"database/sql"
	"errors"
	"fmt"

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
	db *sql.DB // Указатель на подключение к базе данных
}

// AddNew добавляет пользователя в базу данных.
func (ut *UserTable) AddNew(u User) (*User, error) {
	if u.isDefault() {
		return nil, errors.New("User.Add: wrong data! provided *User is empty")
	}

	tx, err := ut.db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	var userId int64
	err = tx.QueryRow(
		"INSERT INTO users (email, password) VALUES ($1, $2) RETURNING user_id",
		u.Email, u.Password,
	).Scan(&userId)
	if err != nil {
		return nil, fmt.Errorf("User.Add: error executing INSERT query: %v", err)
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("User.Add: error committing transaction: %v", err)
	}

	u.Id = userId

	return &u, nil
}

// GetById возвращает данные пользователя из базы данных по указанному идентификатору.
func (ut *UserTable) GetById(u User) (*User, error) {
	if u.isDefault() {
		return nil, errors.New("User.Get: wrong data! provided *User is empty")
	}
	if u.Id == 0 {
		return nil, errors.New("User.Get: wrong data! provided *User.Id is empty")
	}

	tx, err := ut.db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRow("SELECT email, password FROM users WHERE user_id = $1 AND NOT user_is_deleted", u.Id)
	if row.Err() != nil {
		return nil, fmt.Errorf("User.Get: %v", err)
	}

	var email, password string
	err = row.Scan(&email, &password)
	if err != nil {
		return nil, err
	}

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("User.Get: error committing transaction: %v", err)
	}

	u.Email = email
	u.Password = password

	return &u, nil
}

// Check проверяет наличие пользователя в базе данных и соответствие введенного пароля.
func (ut *UserTable) Check(u User) (*User, error) {
	if u.isDefault() {
		return nil, errors.New("User.Check: wrong data! *User is empty")
	}

	tx, err := ut.db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	var id int64
	var pass string

	row := tx.QueryRow("SELECT password, user_id FROM users WHERE email = $1 AND NOT user_is_deleted", u.Email)
	if row.Err() != nil {
		return nil, fmt.Errorf("User.Check: %v", err)
	}

	err = row.Scan(&pass, &id)
	if err != nil {
		return nil, err
	}

	if err := bcrypt.CompareHashAndPassword([]byte(pass), []byte(u.Password)); err != nil {
		return nil, errors.New("Users.Check: incorrect password!")
	}

	u.Id = id

	if err := tx.Commit(); err != nil {
		return nil, fmt.Errorf("User.Check: error committing transaction: %v", err)
	}

	return &u, nil
}

// Delete удаляет данные пользователя из базы данных по указанному идентификатору.
func (ut *UserTable) Delete(u User) error {
	if u.isDefault() {
		return errors.New("User.Delete: wrong data! *User.Id is empty")
	}

	tx, err := ut.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.Exec(`
		UPDATE users
	SET user_is_deleted = TRUE
	WHERE user_id = $1;
	`, u.Id)
	if err != nil {
		return fmt.Errorf("User.Delete: %v", err)
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("User.Delete: error committing transaction: %v", err)
	}

	return nil
}

func newUserTable(db *sql.DB, query string) (*UserTable, error) {
	_, err := db.Exec(query)
	if err != nil {
		return nil, fmt.Errorf("failed to create users table: %v", err)
	}

	return &UserTable{db: db}, nil
}
