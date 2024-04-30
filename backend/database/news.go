package database

import (
	"database/sql"
	"errors"
	"fmt"
	"time"

	"github.com/lib/pq"
)

// News представляет сущность новости в системе.
type News struct {
	Id              int      `json:"id"`                // Id новости
	Header          string   `json:"header"`            // Заголовок новости
	Link            string   `json:"link,omitempty"`    // Ссылка на новость
	Content         string   `json:"content,omitempty"` // Содержание новости (текст)
	ImageLinks      []string `json:"image_link"`        // Ссылки на изображения
	Tags            []string `json:"tags"`              // Теги
	PublicationTime string   `json:"publication_time"`  // Время публикации новости в формате "DD.MM.YYYY"
}

// isDefault проверяет, переданы ли какие-либо данные в структуру News.
func (n *News) isDefault() bool {
	return n.Id == 0 && n.Header == "" && n.Link == "" && n.Content == "" && n.ImageLinks == nil && n.Tags == nil && n.PublicationTime == ""
}

// NewsTable предоставляет методы для работы с таблицей новостей в базе данных.
type NewsTable struct {
	db *sql.DB    // Указатель на подключение к базе данных
	qm queryMaker // Исполнитель ОБЫЧНЫХ sql запросов
}

// Add добавляет новость в базу данных.
// Принимает указатель на News с заполненными полями.
// Возвращает nil при успешном добавлении.
//
// Прим:
// n := &News{Header: "Новость", Link: "http://example.com", Content: "Содержание", ImageLinks: []string{"http://example.com/image1.jpg"}, Tags: []string{"tag1", "tag2"}, PublicationTime: "01.01.2024"}
// err := ...Add(n) // err == nil если все хорошо
func (nt *NewsTable) Add(n *News) error {
	if n.isDefault() {
		return errors.New("News.Add: wrong data! provided *News is empty")
	}

	formattedDate, err := time.Parse("02.01.2006", n.PublicationTime)
	if err != nil {
		return err
	}
	n.PublicationTime = formattedDate.Format("2006-01-02 15:04:05")

	err = nt.qm.makeInsert(nt.db,
		`INSERT INTO news (header, link, news_text, image_links, tags, publication_time)
			SELECT $1, $2, $3, $4, $5, $6
			WHERE NOT EXISTS (
				SELECT 1 FROM news WHERE header = $1 AND publication_time = $6
			)
		`,
		n.Header, n.Link, n.Content, pq.Array(n.ImageLinks), pq.Array(n.Tags), n.PublicationTime)

	if err != nil {
		return fmt.Errorf("News.Add: %v", err)
	}

	return nil
}

// GetById возвращает новость из базы данных по указанному идентификатору.
// Принимает указатель на News с заполненным полем Id.
// Возвращает заполненную структуру News и nil при успешном запросе.
//
// Прим:
// n := &News{Id: 123}
// news, err := ...GetById(n) // err == nil если все хорошо
func (nt *NewsTable) GetById(n *News) (*News, error) {
	if n.isDefault() {
		return nil, errors.New("News.GetById: wrong data! provided *News is empty")
	}

	if n.Id == 0 {
		return nil, errors.New("News.GetById: wrong data! provided *News has empty ID")
	}

	rows, err := nt.qm.makeSelect(nt.db,
		"SELECT header, link, news_text, image_links, tags, publication_time FROM news WHERE news_id = $1",
		n.Id,
	)
	defer rows.Close()

	if err != nil {
		return nil, fmt.Errorf("News.GetById: %v", err)
	}

	if rows.Next() {
		rows.Scan(&n.Header, &n.Link, &n.Content, pq.Array(&n.ImageLinks), pq.Array(&n.Tags), &n.PublicationTime)
	} else {
		return nil, errors.New("News.GetById: could not find any News with provided *News.Id")
	}

	return n, nil
}

// GetLatestBlocks возвращает указанное количество последних новостных блоков.
// Принимает количество блоков и смещение.
// Возвращает срез News и nil при успешном запросе.
//
// Прим:
// blocks, err := ...GetLatestBlocks(10, 0) // Получить 10 последних новостных блоков
func (nt *NewsTable) GetLatestBlocks(count, offset int) (*[]News, error) {
	rows, err := nt.qm.makeSelect(nt.db,
		"SELECT news_id, header, link, image_links, publication_time FROM news ORDER BY publication_time DESC LIMIT $1 OFFSET $2",
		count, offset,
	)

	if err != nil {
		return nil, fmt.Errorf("News.GetLatest: %v", err)
	}

	var resultNewsArr []News
	var resultNews News

	for rows.Next() {
		rows.Scan(&resultNews.Id, &resultNews.Header, &resultNews.Link, pq.Array(&resultNews.ImageLinks), &resultNews.PublicationTime)
		resultNewsArr = append(resultNewsArr, resultNews)
	}

	return &resultNewsArr, nil
}

// Delete удаляет новость из базы данных по указанному идентификатору.
// Принимает указатель на News с заполненным полем Id.
// Возвращает nil при успешном удалении.
//
// Прим:
// n := &News{Id: 123}
// err := ...Delete(n) // err == nil если все хорошо
func (nt *NewsTable) Delete(n *News) error {
	if n.isDefault() {
		return errors.New("News.Delete: wrong data! provided *News is empty")
	}

	if n.Id == 0 {
		return errors.New("News.Delete: wrong data! provided *News has empty ID")
	}

	err := nt.qm.makeDelete(nt.db,
		"DELETE FROM news WHERE news_id = $1",
		n.Id)

	if err != nil {
		return fmt.Errorf("News.Delete: %v", err)
	}

	return nil
}
