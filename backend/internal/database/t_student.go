package database

import (
	"database/sql"
	"errors"
	"fmt"

	"github.com/lib/pq"
)

// Student представляет сущность студента в системе.
type Student struct {
	Id       int   `json:"id"`       // Уникальный идентификатор студента
	Group    int   `json:"group"`    // Идентификатор группы студента
	Teachers []int `json:"teachers"` // Идентификаторы преподавателей студента
}

// isDefault проверяет, переданы ли какие-либо данные в структуру Student.
// Необходимо для реализации интерфейса Entity и фильтров в функциях БД.
func (s *Student) isDefault() bool {
	return s.Id == 0 && s.Group == 0 && s.Teachers == nil
}

// StudentTable предоставляет методы для работы с таблицей студентов в базе данных.
type StudentTable struct {
	db *sql.DB // Указатель на подключение к базе данных
}

// Add добавляет студента в базу данных.
func (st *StudentTable) Add(s *Student) error {
	if s.isDefault() {
		return errors.New("Student.Add: wrong data! provided *Student is empty")
	}

	insertQuery := `
		INSERT INTO students (student_id, student_group_id, student_teachers_ids)
		VALUES ($1, $2, $3)
	`
	_, err := st.db.Exec(insertQuery, s.Id, s.Group, pq.Array(s.Teachers))
	if err != nil {
		return fmt.Errorf("Student.Add: %v", err)
	}

	return nil
}

// GetById возвращает данные студента из базы данных по указанному идентификатору.
func (st *StudentTable) GetById(s *Student) (*Student, error) {
	if s.isDefault() {
		return nil, errors.New("Student.GetById: wrong data! provided *Student is empty")
	}

	selectQuery := `
	SELECT student_group_id, student_teachers_ids
	FROM students
	WHERE student_id = $1
	  AND NOT student_is_deleted;

	`
	rows, err := st.db.Query(selectQuery, s.Id)
	if err != nil {
		return nil, fmt.Errorf("Student.GetById: %v", err)
	}
	defer rows.Close()

	if rows.Next() {
		rows.Scan(&s.Group, pq.Array(&s.Teachers))
	}

	return s, nil
}

// GetClasses возвращает классы студента из базы данных.
func (st *StudentTable) GetClasses(s *Student) (*[]Class, error) {
	if s.isDefault() {
		return nil, errors.New("Student.GetClasses: wrong data! provided *Student is empty")
	}
	if s.Id == 0 {
		return nil, errors.New("Student.GetClasses: wrong data! provided *Student.Id is empty")
	}

	selectQuery := `
		SELECT *
		FROM classes
		WHERE $1 = ANY(class_group_ids);
	`
	rows, err := st.db.Query(selectQuery, s.Id)
	if err != nil {
		return nil, fmt.Errorf("Student.GetClasses: %v", err)
	}
	defer rows.Close()

	var resultClasses []Class
	var resultClass Class
	for rows.Next() {
		rows.Scan(&resultClass.Id, pq.Array(&resultClass.Groups), &resultClass.Teacher, &resultClass.Count, &resultClass.Weekday, &resultClass.Week, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

// GetClassesByCurrentDay возвращает классы студента по текущему дню недели и неделе.
func (st *StudentTable) GetClassesByDay(s *Student, wc, wd int) (*[]Class, error) {
	if s.isDefault() {
		return nil, errors.New("Student.GetClassesByDay: wrong data! provided *Student is empty")
	}
	if s.Id == 0 {
		return nil, errors.New("Student.GetClassesByDay: wrong data! provided *Student.Id is empty")
	}

	selectQuery := `
		SELECT s.*
		FROM classes s
		JOIN student_groups sg ON s.group_id = ANY(sg.students)
		JOIN students st ON sg.id = st.student_group
		WHERE st.id = $1 AND s.weekday = $2 AND s.Week = $3 AND NOT student_is_deleted
	`
	rows, err := st.db.Query(selectQuery, s.Id, wd, wc)
	if err != nil {
		return nil, fmt.Errorf("Student.GetClassesByDay: %v", err)
	}
	defer rows.Close()

	var resultClasses []Class
	var resultClass Class
	for rows.Next() {
		rows.Scan(&resultClass.Id, pq.Array(&resultClass.Groups), &resultClass.Teacher, &resultClass.Count, &resultClass.Weekday, &resultClass.Week, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

// Delete удаляет данные студента из базы данных по указанному идентификатору.
func (st *StudentTable) Delete(s *Student) error {
	if s.isDefault() {
		return errors.New("Student.Delete: wrong data! Id is empty")
	}

	deleteQuery := `
	UPDATE students
	SET student_is_deleted = TRUE
	WHERE student_id = $1;
	`
	_, err := st.db.Exec(deleteQuery, s.Id)
	if err != nil {
		return fmt.Errorf("Student.Delete: %v", err)
	}

	return nil
}

func newStudentTable(db *sql.DB, query string) (*StudentTable, error) {
	_, err := db.Exec(query)
	if err != nil {
		return nil, fmt.Errorf("failed to create students table: %v", err)
	}

	return &StudentTable{db: db}, nil
}
