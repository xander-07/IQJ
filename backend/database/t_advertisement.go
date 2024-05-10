package database

import (
	"database/sql"
	"errors"
	"fmt"
	"time"
)

// Структура объявления
type Advertisement struct {
	Id             int    `json:"ad_id"`                     // id объявления
	Content        string `json:"ad_content"`                // содержание объявления (текст)
	CreationDate   string `json:"creation_date,omitempty"`   // дата создания объявления
	ExpirationDate string `json:"expiration_date,omitempty"` // срок годности объявления
}

// isDefault проверяет, переданы ли какие-либо данные в структуру Advertisement
func (a *Advertisement) isDefault() bool {
	return a.Id == 0 && a.Content == ""
}

// AdvertisementTable предоставляет методы для работы с таблицей Advertisements
type AdvertisementTable struct {
	db *sql.DB // Указатель на подключение к базе данных
}

// Add добавляет данные в базу данных.
// Принимает указатель на Advertisement с непустым полeм Content\n
// Возвращает nil при успешном добавлении.
//
// Прим:\n
// a := &Advertisement{Content : "123"} // Content != "" !!!!!!\n
// err := ...Add(a) // err == nil если все хорошо
func (at *AdvertisementTable) Add(a *Advertisement) error {
	// Проверяем были ли переданы данные в a
	if a.isDefault() {
		return errors.New("Advertisement.Add: wrong data! provided *Advertisement is empty")
	}

	formattedCreationDate, err := time.Parse("02.01.2006", a.CreationDate)
	if err != nil {
		return err
	}
	a.CreationDate = formattedCreationDate.Format("2006-01-02 15:04:05")

	formattedExpirationDate, err := time.Parse("02.01.2006", a.ExpirationDate)
	if err != nil {
		return err
	}
	a.ExpirationDate = formattedExpirationDate.Format("2006-01-02 15:04:05")

	// Выполнение SQL-запроса напрямую к базе данных
	_, err = at.db.Exec(
		`INSERT INTO advertisements (content, creation_date, expiration_date)
		SELECT $1, $2, $3
		WHERE NOT EXISTS (
			SELECT 1 FROM advertisements WHERE content = $1 AND creation_date = $2
		)`,
		a.Content, a.CreationDate, a.ExpirationDate,
	)

	if err != nil {
		return fmt.Errorf("Advertisement.Add: %v", err)
	}

	return nil
}

// Get возвращает объявления из бд срок годности которых больше текущей даты.
// Возвращает заполненный *[]Advertisement и nil при успешном запросе.
//
// Прим:\n
// ads, err := ...Get() // err == nil если все хорошо
func (at *AdvertisementTable) Get() (*[]Advertisement, error) {
	rows, err := at.db.Query(
		"SELECT advertiesment_id, content, creation_date, expiration_date FROM advertisements WHERE expiration_date > $1 ORDER BY creation_date DESC",
		time.Now(),
	)

	if err != nil {
		return nil, fmt.Errorf("Advertisement.Get: %v", err)
	}

	defer rows.Close()

	var resultAdvertisementArr []Advertisement
	var resultAdvertisement Advertisement

	for rows.Next() {
		if err := rows.Scan(&resultAdvertisement.Id, &resultAdvertisement.Content, &resultAdvertisement.CreationDate, &resultAdvertisement.ExpirationDate); err != nil {
			return nil, err
		}
		resultAdvertisementArr = append(resultAdvertisementArr, resultAdvertisement)
	}
	return &resultAdvertisementArr, nil
}

func (at *AdvertisementTable) GetAll() (*[]Advertisement, error) {
	rows, err := at.db.Query(
		"SELECT * FROM advertisements",
	)

	if err != nil {
		return nil, fmt.Errorf("Advertisement.GetAll: %v", err)
	}

	defer rows.Close()

	var resultAdvertisementArr []Advertisement
	var resultAdvertisement Advertisement

	for rows.Next() {
		if err := rows.Scan(&resultAdvertisement.Id, &resultAdvertisement.Content, &resultAdvertisement.CreationDate, &resultAdvertisement.ExpirationDate); err != nil {
			return nil, err
		}
		resultAdvertisementArr = append(resultAdvertisementArr, resultAdvertisement)
	}
	return &resultAdvertisementArr, nil
}

func (at *AdvertisementTable) Update(a *Advertisement) error {

	if a.isDefault() {
		return errors.New("Advertisement.Update: wrong data! provided *Advertisement is empty")
	}

	_, err := at.db.Exec(
		`UPDATE advertisements
		SET content = $1,
			creation_date = $2,
			expiration_date= $3
			WHERE advertiesment_id = $4`,
		a.Content, a.CreationDate, a.ExpirationDate, a.Id,
	)

	if err != nil {
		return fmt.Errorf("Advertisement.Update: %v", err)
	}

	return nil
}

// Delete удаляет данные из базы данных по заданному Id.
// Принимает указатель на Advertisement с заполненным полем Id,
// возвращает nil при успешном удалении.
//
// Прим:\n
// a := &Advertisement{Id:123} // Id != 0 !!!!!!\n
// err := ...Delete(a) // err == nil если все хорошо
func (at *AdvertisementTable) Delete(a *Advertisement) error {
	// Проверяем передан ли ID рекламного объявления
	if a.Id == 0 {
		return errors.New("Advertisement.Delete: wrong data! provided advertisementID is empty")
	}

	_, err := at.db.Exec(
		"DELETE FROM advertisements WHERE advertiesmentId = $1",
		a.Id,
	)
	if err != nil {
		return fmt.Errorf("Advertisement.Delete: %v", err)
	}

	// Возвращаем nil, так как ошибок не случилось
	return nil
}

func newAdvertisementTable(db *sql.DB, query string) (*AdvertisementTable, error) {
	_, err := db.Exec(query)
	if err != nil {
		return nil, fmt.Errorf("failed to create advertisements table: %v", err)
	}
	return &AdvertisementTable{db: db}, nil
}
