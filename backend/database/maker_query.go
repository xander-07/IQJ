package database

import (
	"database/sql"
	"fmt"
)

// queryMaker предоставляет методы для выполнения SQL-запросов к базе данных.
type queryMaker struct{}

// makeSelect выполняет SELECT SQL-запрос к базе данных.
// Принимает указатель на подключение к базе данных (db), строку SQL-запроса (query) и переменное количество ключей (keys) для подстановки в запрос.
// Возвращает указатель на объект sql.Rows, содержащий результаты запроса, и ошибку при её возникновении.
//
// Прим:
// rows, err := qm.makeSelect(db, "SELECT * FROM users WHERE id = $1", 1)
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
func (qm *queryMaker) makeSelect(db *sql.DB, query string, keys ...interface{}) (*sql.Rows, error) {

	rows, err := db.Query(query, keys...)

	if err != nil {
		return nil, fmt.Errorf("problem with selecting! %v\ncaused by: %v", err, query)
	}

	return rows, nil
}

// makeInsert выполняет INSERT SQL-запрос к базе данных.
// Принимает указатель на подключение к базе данных (db), строку SQL-запроса (query) и переменное количество значений (values) для подстановки в запрос.
// Возвращает ошибку при её возникновении.
//
// Прим:
// err := qm.makeInsert(db, "INSERT INTO users (name, age) VALUES ($1, $2)", "John", 30)
//
//	if err != nil {
//	    // Обработка ошибки
//	}
func (qm *queryMaker) makeInsert(db *sql.DB, query string, values ...interface{}) error {

	// Выполняем дефолтный инсерт в базу данных (вставка в таблицу)
	_, err := db.Exec(query, values...)

	if err != nil {
		return fmt.Errorf("problem with inserting! %v\ncaused by: %v", err, query)
	}

	return nil
}

// makeUpdate выполняет UPDATE SQL-запрос к базе данных.
// Принимает указатель на подключение к базе данных (db), строку SQL-запроса (query), ключ (key) и переменное количество значений (values) для подстановки в запрос.
// Возвращает ошибку при её возникновении.
//
// Прим:
// err := qm.makeUpdate(db, "UPDATE users SET age = $1 WHERE name = $2", "John", 31)
//
//	if err != nil {
//	    // Обработка ошибки
//	}
func (qm *queryMaker) makeUpdate(db *sql.DB, query string, key interface{}, values ...interface{}) error {

	values = append(values, &key)

	_, err := db.Exec(query, values...)

	if err != nil {
		return fmt.Errorf("problem with updating! %v\ncaused by: %v", err, query)
	}

	return nil
}

// makeDelete выполняет DELETE SQL-запрос к базе данных.
// Принимает указатель на подключение к базе данных (db), строку SQL-запроса (query) и ключ (key) для подстановки в запрос.
// Возвращает ошибку при её возникновении.
//
// Прим:
// err := qm.makeDelete(db, "DELETE FROM users WHERE id = $1", 1)
//
//	if err != nil {
//	    // Обработка ошибки
//	}
func (qm *queryMaker) makeDelete(db *sql.DB, query string, key interface{}) error {

	_, err := db.Exec(query, key)
	if err != nil {
		return fmt.Errorf("problem with deleting! %v\ncaused by: %v", err, query)
	}

	return nil
}
