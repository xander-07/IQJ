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
	IsForStudents   bool     `json:"is_for_students"`   // Для кого предназначена новость (для студентов -> true)
	Author          string   `json:"author_name"`       // id автора новости
	PublicationTime string   `json:"publication_time"`  // Время публикации новости в формате "DD.MM.YYYY"
}

// isDefault проверяет, переданы ли какие-либо данные в структуру News.
func (n *News) isDefault() bool {
	return n.Id == 0 && n.Header == "" && n.Link == "" && n.Content == "" && n.ImageLinks == nil && n.Tags == nil && n.PublicationTime == ""
}

// NewsTable предоставляет методы для работы с таблицей новостей в базе данных.
type NewsTable struct {
	db *sql.DB // Указатель на подключение к базе данных
}

// Add добавляет новость в базу данных.
func (nt *NewsTable) Add(n News) error {
	if n.isDefault() {
		return errors.New("News.Add: wrong data! provided *News is empty")
	}
	formattedDate, err := time.Parse("02.01.2006", n.PublicationTime)
	if err != nil {
		return err
	}
	n.PublicationTime = formattedDate.Format("2006-01-02 15:04:05")
	// Подготовим запрос на добавление новости
	insertQuery := `
		INSERT INTO news (header, link, news_text, image_links, tags, is_for_students, news_author_id, publication_time)
		SELECT $1, $2, $3, $4, $5, $6, $7, $8
		WHERE NOT EXISTS (
			SELECT 1 FROM news WHERE header = $1 AND publication_time = $8
		)
	`
	// Выполним запрос
	_, err = nt.db.Exec(insertQuery,
		n.Header, n.Link, n.Content, pq.Array(n.ImageLinks), pq.Array(n.Tags), n.IsForStudents, n.Author, n.PublicationTime)
	if err != nil {
		return fmt.Errorf("News.Add: %v", err)
	}
	return nil
}

// GetById возвращает новость из базы данных по указанному идентификатору.
func (nt *NewsTable) GetById(n News) (*News, error) {
	if n.isDefault() {
		return nil, errors.New("News.GetById: wrong data! provided *News is empty")
	}

	if n.Id == 0 {
		return nil, errors.New("News.GetById: wrong data! provided *News has empty ID")
	}

	// Подготовим запрос на получение новости по ID
	selectQuery := `
		SELECT header, link, news_text, image_links, tags, is_for_students, news_author_id, publication_time
		FROM news WHERE news_id = $1
	`

	// Выполним запрос и получим строки
	row := nt.db.QueryRow(selectQuery, n.Id)

	// Создадим новую переменную News для заполнения данными
	var news News
	// Заполним переменную данными из строки
	err := row.Scan(&news.Header, &news.Link, &news.Content, pq.Array(&news.ImageLinks), pq.Array(&news.Tags), &news.IsForStudents, &news.Author, &news.PublicationTime)
	if err != nil {
		return nil, fmt.Errorf("News.GetById: %v", err)
	}

	// Вернем заполненную структуру News и nil
	return &news, nil
}

// GetAll возвращает все новости из базы данных.
func (nt *NewsTable) GetAll() (*[]News, error) {
	// Подготовим запрос на получение всех новостей
	selectQuery := `
		SELECT news_id, header, link, news_text, image_links, tags, is_for_students, news_author_id, publication_time
		FROM news
	`

	// Выполним запрос и получим строки
	rows, err := nt.db.Query(selectQuery)
	if err != nil {
		return nil, fmt.Errorf("News.GetById: %v", err)
	}
	defer rows.Close()

	// Создадим срез для хранения всех новостей
	var newsSlice []News
	// Пройдемся по всем строкам и заполним структуру News
	for rows.Next() {
		var news News
		err := rows.Scan(&news.Id, &news.Header, &news.Link, &news.Content, pq.Array(&news.ImageLinks), pq.Array(&news.Tags), &news.IsForStudents, &news.Author, &news.PublicationTime)
		if err != nil {
			return nil, fmt.Errorf("News.GetById: %v", err)
		}
		newsSlice = append(newsSlice, news)
	}

	// Вернем срез с новостями и nil
	return &newsSlice, nil
}

// func (nt *NewsTable) GetNewsByHeader(text []byte)(*[]News,error){
// 	selectQuery := `
// 		SELECT news_id, header, link, image_links, tags, publication_time
// 		FROM news ORDER BY publication_time DESC LIMIT $1 OFFSET $2
// 	`
// }

// Остальные методы не изменились и остаются теми же

// GetLatestBlocks возвращает указанное количество последних новостных блоков.
func (nt *NewsTable) GetLatestBlocks(count, offset int) (*[]News, error) {
	// Подготовим запрос на получение последних новостных блоков
	selectQuery := `
		SELECT news_id, header, link, image_links, tags, news_author_id, publication_time
		FROM news ORDER BY publication_time DESC LIMIT $1 OFFSET $2
	`

	// Выполним запрос и получим строки
	rows, err := nt.db.Query(selectQuery, count, offset)
	if err != nil {
		return nil, fmt.Errorf("News.GetLatest: %v", err)
	}
	defer rows.Close()

	// Создадим срез для хранения последних новостных блоков
	var resultNewsArr []News
	// Пройдемся по всем строкам и заполним структуру News
	for rows.Next() {
		var resultNews News
		err := rows.Scan(&resultNews.Id, &resultNews.Header, &resultNews.Link, pq.Array(&resultNews.ImageLinks), pq.Array(&resultNews.Tags), &resultNews.Author, &resultNews.PublicationTime)
		if err != nil {
			return nil, fmt.Errorf("News.GetLatest: %v", err)
		}
		resultNewsArr = append(resultNewsArr, resultNews)
	}

	// Вернем срез с последними новостными блоками и nil
	return &resultNewsArr, nil
}

// GetLatestBlocksForStudents возвращает указанное количество последних новостных блоков для студентов.
func (nt *NewsTable) GetLatestBlocksForStudents(count, offset int) (*[]News, error) {
	// Подготовим запрос на получение последних новостных блоков для студентов
	selectQuery := `
		SELECT news_id, header, link, image_links, news_author_id, publication_time
		FROM news WHERE is_for_students = true
		ORDER BY publication_time DESC LIMIT $1 OFFSET $2
	`

	// Выполним запрос и получим строки
	rows, err := nt.db.Query(selectQuery, count, offset)
	if err != nil {
		return nil, fmt.Errorf("News.GetLatestForStudents: %v", err)
	}
	defer rows.Close()

	// Создадим срез для хранения последних новостных блоков для студентов
	var resultNewsArr []News
	// Пройдемся по всем строкам и заполним структуру News
	for rows.Next() {
		var resultNews News
		err := rows.Scan(&resultNews.Id, &resultNews.Header, &resultNews.Link, pq.Array(&resultNews.ImageLinks), &resultNews.Author, &resultNews.PublicationTime)
		if err != nil {
			return nil, fmt.Errorf("News.GetLatestForStudents: %v", err)
		}
		resultNewsArr = append(resultNewsArr, resultNews)
	}

	// Вернем срез с последними новостными блоками для студентов и nil
	return &resultNewsArr, nil
}

// Delete удаляет новость из базы данных по указанному идентификатору.
func (nt *NewsTable) Delete(n News) error {
	if n.isDefault() {
		return errors.New("News.Delete: wrong data! provided *News is empty")
	}

	if n.Id == 0 {
		return errors.New("News.Delete: wrong data! provided *News has empty ID")
	}

	// Подготовим запрос на удаление новости по ID
	deleteQuery := `
		DELETE FROM news WHERE news_id = $1
	`

	// Выполним запрос
	_, err := nt.db.Exec(deleteQuery, n.Id)
	if err != nil {
		return fmt.Errorf("News.Delete: %v", err)
	}

	return nil
}

// Update обновляет новость в базе данных по указанному идентификатору.
func (nt *NewsTable) Update(n News) error {
	if n.isDefault() {
		return errors.New("News.Update: wrong data! provided *News is empty")
	}

	// Подготовим запрос на обновление новости по ID
	updateQuery := `
		UPDATE news
		SET header = $1,
			news_text = $2,
			image_links = $3,
			tags = $4,
			is_for_students = $5,
			news_author_id = $6
			publication_time = $7
		WHERE news_id = $8
	`

	// Выполним запрос
	_, err := nt.db.Exec(updateQuery, n.Header, n.Content, pq.Array(n.ImageLinks), pq.Array(n.Tags), n.IsForStudents, n.Author, n.PublicationTime, n.Id)
	if err != nil {
		return fmt.Errorf("News.Update: %v", err)
	}

	return nil
}

func newNewsTable(db *sql.DB, query string) (*NewsTable, error) {
	_, err := db.Exec(query)
	if err != nil {
		return nil, fmt.Errorf("failed to create advertisement table: %v", err)
	}

	return &NewsTable{db: db}, nil
}
