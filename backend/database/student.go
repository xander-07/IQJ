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
	db *sql.DB    // Указатель на подключение к базе данных
	qm queryMaker // Исполнитель ОБЫЧНЫХ sql запросов
}

// Add добавляет студента в базу данных.
// Принимает указатель на Student с заполненными полями.
// Возвращает nil при успешном добавлении.
//
// Прим:
// s := &Student{Id: 1, Group: 101, Teachers: []int{1, 2, 3}}
// err := ...Add(s) // err == nil если все хорошо
func (st *StudentTable) Add(s *Student) error {

	// Проверяем были ли переданы данные в s
	if s.isDefault() {
		return errors.New("Student.Add: wrong data! provided *Student is empty")
	}

	// Используем базовую функцию для создания и исполнения insert запроса
	err := st.qm.makeInsert(st.db,
		"INSERT INTO students (student_id, student_group_id, student_teachers_ids) VALUES ($1, $2, $3)",
		s.Id, s.Group, pq.Array(s.Teachers),
	)

	if err != nil {
		return fmt.Errorf("Student.Add: %v", err)
	}

	return nil
}

// GetById возвращает данные студента из базы данных по указанному идентификатору.
// Принимает указатель на Student с заполненным полем Id.
// Возвращает заполненную структуру Student и nil при успешном запросе.
//
// Прим:
// s := &Student{Id: 1}
// student, err := ...GetById(s) // err == nil если все хорошо
func (st *StudentTable) GetById(s *Student) (*Student, error) {

	// Проверяем переданы ли данные в функцию
	if s.isDefault() {
		return nil, errors.New("Student.GetById: wrong data! provided *Student is empty")
	}
	// Проверяем передан ли id
	if s.Id == 0 {
		return nil, errors.New("Student.GetById: wrong data! provided *Student.Id is empty")
	}

	// Используем базовую функцию для формирования и исполнения select запроса
	rows, err := st.qm.makeSelect(st.db,
		"SELECT student_group_id, student_teachers_ids FROM students WHERE student_id = $1",
		s.Id)

	// Проверяем ошибку select'а
	if err != nil {
		return nil, fmt.Errorf("Student.GetById: %v", err)
	}

	// Извлекаем данные из результата запроса и заполняем структуру Student
	if rows.Next() {
		rows.Scan(&s.Group, pq.Array(&s.Teachers))
	}

	return s, nil
}

// GetClasses возвращает классы студента из базы данных.
// Принимает указатель на Student с заполненным полем Id.
// Возвращает срез Class и nil при успешном запросе.
//
// Прим:
// s := &Student{Id: 1}
// classes, err := ...GetClasses(s) // err == nil если все хорошо
func (st *StudentTable) GetClasses(s *Student) (*[]Class, error) {

	// Проверяем переданы ли данные в функцию
	if s.isDefault() {
		return nil, errors.New("Student.GetClasses: wrong data! provided *Student is empty")
	}
	// Проверяем передан ли id
	if s.Id == 0 {
		return nil, errors.New("Student.GetClasses: wrong data! provided *Student.Id is empty")
	}

	// Используем базовую функцию для формирования и исполнения select запроса
	classes, err := st.qm.makeSelect(st.db,
		`SELECT s.*
			FROM schedule s
			JOIN student_groups sg ON s.group_id = ANY(sg.students)
			WHERE $1 = ANY(sg.students);
			`, s.Id)

	// Проверяем ошибку select'а
	if err != nil {
		return nil, fmt.Errorf("Student.GetClasses: %v", err)
	}

	var resultClasses []Class
	var resultClass Class

	// Извлекаем данные из результата запроса и заполняем структуру Class
	for classes.Next() {
		classes.Scan(&resultClass.Id, pq.Array(&resultClass.Groups), &resultClass.Teacher, &resultClass.Count, &resultClass.Weekday, &resultClass.Week, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

// GetClassesByCurrentDay возвращает классы студента по текущему дню недели и неделе.
// Принимает указатель на Student с заполненными полями Id, Week и Weekday.
// Возвращает срез Class и nil при успешном запросе.
//
// Прим:
// s := &Student{Id: 1, Week: 1, Weekday: 3}
// classes, err := ...GetClassesByCurrentDay(s, 1, 3) // Получить классы на 3-м дне недели первой недели
func (st *StudentTable) GetClassesByCurrentDay(s *Student, wc, wd int) (*[]Class, error) {

	// Проверяем переданы ли данные в функцию
	if s.isDefault() {
		return nil, errors.New("Student.GetClassesByWeekday: wrong data! provided *Student is empty")
	}
	// Проверяем передан ли id
	if s.Id == 0 {
		return nil, errors.New("Student.GetClassesByWeekday: wrong data! provided *Student.Id is empty")
	}

	// Используем базовую функцию для формирования и исполнения select запроса
	classes, err := st.qm.makeSelect(st.db,
		`SELECT s.*
			FROM schedule s
			JOIN student_groups sg ON s.group_id = ANY(sg.students)
			JOIN students st ON sg.id = st.student_group
			WHERE st.id = $1 AND s.weekday = $2 AND s.Week = $3`,
		s.Id, wd, wc)

	// Проверяем ошибку select'а
	if err != nil {
		return nil, fmt.Errorf("Student.GetClassesByWeekday: %v", err)
	}

	var resultClasses []Class
	var resultClass Class

	// Извлекаем данные из результата запроса и заполняем структуру Class
	for classes.Next() {
		classes.Scan(&resultClass.Id, pq.Array(&resultClass.Groups), &resultClass.Teacher, &resultClass.Count, &resultClass.Weekday, &resultClass.Week, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

// Delete удаляет данные студента из базы данных по указанному идентификатору.
// Принимает указатель на Student с заполненным полем Id.
// Возвращает nil при успешном удалении.
//
// Прим:
// s := &Student{Id: 1}
// err := ...Delete(s) // err == nil если все хорошо
func (st *StudentTable) Delete(s *Student) error {
	// Проверяем дали ли нам нужные данные
	if s.isDefault() {
		return errors.New("Student.Delete: wrong data! *UserData.Id is empty")
	}

	// Для удаления используем базовую функцию
	err := st.qm.makeDelete(st.db, "DELETE FROM users_data WHERE id = $1", s.Id)

	if err != nil {
		return fmt.Errorf("Student.Delete: %v", err)
	}

	return nil
}
