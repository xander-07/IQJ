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
	db *sql.DB    // Указатель на подключение к базе данных
	qm queryMaker // Исполнитель ОБЫЧНЫХ sql запросов
}

// Add добавляет преподавателя в базу данных.
// Принимает указатель на Teacher с заполненными полями.
// Возвращает nil при успешном добавлении.
//
// Прим:
// teacher := &Teacher{Id: 1, Groups: []int{101, 102}}
// err := ...Add(teacher) // err == nil если все хорошо
func (tt *TeacherTable) Add(t *Teacher) error {

	// Проверяем были ли переданы данные в t
	if t.isDefault() {
		return errors.New("Teachers.Add: wrong data! provided *Teacher is empty")
	}

	// Используем базовую функцию для создания и исполнения insert запроса
	err := tt.qm.makeInsert(tt.db,
		"INSERT INTO teachers (teacher_id,teacher_students_groups_ids) VALUES ($1, $2)",
		&t.Id, &t.Groups,
	)

	if err != nil {
		return fmt.Errorf("Teachers.Add: %v", err)
	}

	return nil
}

// GetById возвращает данные преподавателя из базы данных по указанному идентификатору.
// Принимает указатель на Teacher с заполненным полем Id.
// Возвращает заполненную структуру Teacher и nil при успешном запросе.
//
// Прим:
// teacher := &Teacher{Id: 1}
// teacher, err := ...GetById(teacher) // err == nil если все хорошо
func (tt *TeacherTable) GetById(t *Teacher) (*Teacher, error) {

	// Проверяем переданы ли данные в функцию
	if t.isDefault() {
		return nil, errors.New("Teachers.GetById: wrong data! provided *Teacher is empty")
	}
	// Проверяем передан ли id
	if t.Id == 0 {
		return nil, errors.New("Teachers.GetById: wrong data! provided *Teacher.Id is empty")
	}

	// Используем базовую функцию для формирования и исполнения select запроса
	row, err := tt.qm.makeSelect(tt.db,
		"SELECT teacher_students_groups_ids FROM teachers WHERE teacher_id = $1",
		t.Id)

	// Проверяем ошибку select'а
	if err != nil {
		return nil, fmt.Errorf("Teachers.GetById: %v", err)
	}

	// Сканируем данные из результата запроса и заполняем структуру Teacher
	row.Scan(pq.Array(*&t.Groups))

	return t, nil
}

// UpdateGroups обновляет данные о группах, в которых преподает преподаватель.
// Принимает указатель на Teacher с заполненным полем Id и новым списком групп.
// Возвращает заполненную структуру Teacher и nil при успешном запросе.
//
// Прим:
// teacher := &Teacher{Id: 1, Groups: []int{101, 102}}
// teacher, err := ...UpdateGroups(teacher) // err == nil если все хорошо
func (tt *TeacherTable) UpdateGroups(t *Teacher) (*Teacher, error) {
	// Проверяем переданы ли данные в функцию
	if t.isDefault() {
		return nil, errors.New("Teachers.UpdateGroups: wrong data! provided *Teacher is empty")
	}
	// Проверяем передан ли id
	if t.Id == 0 {
		return nil, errors.New("Teachers.UpdateGroups: wrong data! provided *Teacher.Id is empty")
	}

	// Используем базовую функцию для формирования и исполнения update запроса
	err := tt.qm.makeUpdate(tt.db,
		"UPDATE teachers SET  teacher_students_groups_ids = $1 WHERE teacher_id = $2",
		t.Id, &t.Groups)

	// Проверяем ошибку update'а
	if err != nil {
		return nil, fmt.Errorf("Teachers.UpdateGroups: %v", err)
	}
	return t, nil
}
