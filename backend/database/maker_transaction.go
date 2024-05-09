package database

import (
	"database/sql"
	"errors"
	"fmt"
)

// transactionMaker предоставляет методы для выполнения SQL-запросов в рамках транзакции к базе данных.
type transactionMaker struct{}

// makeSelect выполняет SELECT SQL-запрос в рамках транзакции к базе данных.
// Принимает указатель на подключение к базе данных (db), строку SQL-запроса (query) и ключ (key) для подстановки в запрос.
// Возвращает указатель на объект sql.Rows, содержащий результаты запроса, и ошибку при её возникновении.
//
// Прим:
// rows, err := tm.makeSelect(db, "SELECT * FROM users WHERE id = $1", 1)
//
//	if err != nil {
//	    // Обработка ошибки
//	}
//
// defer rows.Close()
//
//	for rows.Next() {
//	    // Обработка результатов запроса
//	}
func (tm *transactionMaker) makeSelect(db *sql.DB, query string, key ...interface{}) (*sql.Rows, error) {
	tx, err := db.Begin()
	if err != nil {
		return nil, err
	}

	rows, err := tx.Query(query, key...)
	if err != nil {
		tx.Rollback()
		return nil, fmt.Errorf("problem with selecting! %v\ncaused by: %v", err, query)
	}

	return rows, nil
}

// makeInsert выполняет INSERT SQL-запрос в рамках транзакции к базе данных.
// Принимает указатель на подключение к базе данных (db), строку SQL-запроса (query) и переменное количество значений (values) для подстановки в запрос.
// Возвращает ошибку при её возникновении.
//
// Прим:
// err := tm.makeInsert(db, "INSERT INTO users (name, age) VALUES ($1, $2)", "John", 30)
//
//	if err != nil {
//	    // Обработка ошибки
//	}
func (tm *transactionMaker) makeInsert(db *sql.DB, query string, values ...interface{}) (*sql.Row, error) {
	tx, err := db.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRow(query, values...)
	if row == nil {
		return nil, errors.New("no row returned after insertion")
	}

	if err := tx.Commit(); err != nil {
		return nil, err
	}

	return row, nil
}

// makeUpdate выполняет UPDATE SQL-запрос в рамках транзакции к базе данных.
// Принимает указатель на подключение к базе данных (db), строку SQL-запроса (query), ключ (key) и переменное количество значений (values) для подстановки в запрос.
// Возвращает ошибку при её возникновении.
//
// Прим:
// err := tm.makeUpdate(db, "UPDATE users SET age = $1 WHERE name = $2", 31, "John")
//
//	if err != nil {
//	    // Обработка ошибки
//	}
func (tm *transactionMaker) makeUpdate(db *sql.DB, query string, key interface{}, values ...interface{}) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	values = append(values, &key)

	_, err = tx.Exec(query, values...)
	if err != nil {
		return fmt.Errorf("problem with updating! %v\ncaused by: %v", err, query)
	}

	if err := tx.Commit(); err != nil {
		return err
	}

	return nil
}

// makeDelete выполняет DELETE SQL-запрос в рамках транзакции к базе данных.
// Принимает указатель на подключение к базе данных (db), строку SQL-запроса (query) и ключ (key) для подстановки в запрос.
// Возвращает ошибку при её возникновении.
//
// Прим:
// err := tm.makeDelete(db, "DELETE FROM users WHERE id = $1", 1)
//
//	if err != nil {
//	    // Обработка ошибки
//	}
func (tm *transactionMaker) makeDelete(db *sql.DB, query string, key interface{}) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.Exec(query, key)
	if err != nil {
		return fmt.Errorf("problem with deleting! %v\ncaused by: %v", err, query)
	}

	if err := tx.Commit(); err != nil {
		return err
	}

	return nil
}
