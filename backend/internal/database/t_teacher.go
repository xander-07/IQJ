package database

import (
	"database/sql"
	"errors"
	"fmt"

	"github.com/lib/pq"
)

// Teacher представляет сущность преподавателя в системе.
type Teacher struct {
	Id     int   `json:"id"`     // Уникальный идентификатор преподавателя
	Groups []int `json:"groups"` // Идентификаторы групп, в которых преподает преподаватель
}

// isDefault проверяет, переданы ли какие-либо данные в структуру Teacher.
// Необходимо для реализации интерфейса Entity и фильтров в функциях БД.
func (t *Teacher) isDefault() bool {
	return t.Id == 0 && t.Groups == nil
}

// TeacherTable предоставляет методы для работы с таблицей преподавателей в базе данных.
type TeacherTable struct {
	db *sql.DB // Указатель на подключение к базе данных
}

// Add добавляет преподавателя в базу данных.
func (tt *TeacherTable) Add(t Teacher) error {
	if t.isDefault() {
		return errors.New("Teachers.Add: wrong data! provided *Teacher is empty")
	}

	_, err := tt.db.Exec("INSERT INTO teachers (teacher_id, teacher_students_groups_ids) VALUES ($1, $2)",
		t.Id, pq.Array(t.Groups),
	)

	if err != nil {
		return fmt.Errorf("Teachers.Add: %v", err)
	}

	return nil
}

// GetById возвращает данные преподавателя из базы данных по указанному идентификатору.
func (tt *TeacherTable) GetById(t Teacher) (*Teacher, error) {
	if t.isDefault() {
		return nil, errors.New("Teachers.GetById: wrong data! provided *Teacher is empty")
	}
	if t.Id == 0 {
		return nil, errors.New("Teachers.GetById: wrong data! provided *Teacher.Id is empty")
	}

	row := tt.db.QueryRow("SELECT teacher_students_groups_ids FROM teachers WHERE teacher_id = $1 AND NOT teacher_is_deleted", t.Id)
	if row.Err() != nil {
		return nil, fmt.Errorf("Teachers.GetById: %v", row.Err().Error())
	}

	if err := row.Scan(pq.Array(&t.Groups)); err != nil {
		return nil, fmt.Errorf("Teachers.GetById: %v", err)
	}

	return &t, nil
}

// UpdateGroups обновляет данные о группах, в которых преподает преподаватель.
func (tt *TeacherTable) UpdateGroups(t Teacher) (*Teacher, error) {
	if t.isDefault() {
		return nil, errors.New("Teachers.UpdateGroups: wrong data! provided *Teacher is empty")
	}
	if t.Id == 0 {
		return nil, errors.New("Teachers.UpdateGroups: wrong data! provided *Teacher.Id is empty")
	}

	_, err := tt.db.Exec(
		"UPDATE teachers SET teacher_students_groups_ids = $1 WHERE teacher_id = $2 AND NOT teacher_is_deleted",
		pq.Array(&t.Groups), t.Id,
	)

	if err != nil {
		return nil, fmt.Errorf("Teachers.UpdateGroups: %v", err)
	}

	return &t, nil
}

func (tt *TeacherTable) Delete(t Teacher) error {
	if t.isDefault() {
		return errors.New("Teacher.Delete: wrong data! Id is empty")
	}

	deleteQuery := `
		UPDATE teachers
		SET teacher_is_deleted = TRUE
		WHERE teacher_id = $1;
		`
	_, err := tt.db.Exec(deleteQuery, t.Id)
	if err != nil {
		return fmt.Errorf("Teacher.Delete: %v", err)
	}

	return nil

}

func newTeacherTable(db *sql.DB, query string) (*TeacherTable, error) {
	_, err := db.Exec(query)
	if err != nil {
		return nil, fmt.Errorf("failed to create teachers table: %v", err)
	}

	return &TeacherTable{db: db}, nil
}
