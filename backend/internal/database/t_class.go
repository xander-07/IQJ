package database

import (
	"database/sql"
	"errors"
	"fmt"

	"github.com/lib/pq"
)

// Структура учебной пары
type Class struct {
	Id          int      `json:"class_id"`                 // Id пары
	Groups      []int    `json:"class_group_ids"`          // Список Id групп, для которых пара
	GroupsNames []string `json:"class_group_names"`        // список названий групп, т.к. не все группы есть в таблице учебных групп
	Teacher     int      `json:"class_teacher_id"`         // Id преподавателя, который ведет пару
	TeacherName string   `json:"class_teacher_name"`       // фио преподавателя
	Count       int      `json:"class_count"`              // Какая пара по счету за день
	Weekday     int      `json:"class_weekday"`            // Номер дня недели
	Week        int      `json:"class_week"`               // Номер учебной неделяя
	Name        string   `json:"class_name"`               // Название пары
	Type        string   `json:"class_type"`               // Тип пары
	Location    string   `json:"class_location,omitempty"` // Местонахождение
}

// Проверяет переданы ли в структуру какие-либо данные
func (c *Class) isDefault() bool {
	return c.Id == 0 && c.Groups == nil && c.GroupsNames == nil && c.TeacherName == "" && c.Teacher == 0 && c.Count == 0 && c.Weekday == 0 && c.Week == 0 && c.Name == "" && c.Type == "" && c.Location == ""
}

// Структура для взаимодействия с таблицой Classes
type ClassTable struct {
	db *sql.DB // Указатель на подключение к бд
}

// Add добавляет данные в базу данных.
// Принимает Class с непустыми полями Groups, Teacher, Count, Weekday, Week, Name, Type, Location\n
// Возвращает nil при успешном добавлении.
//
// Прим:\n
// a := &Class{Groups: []int{1,2,3}, Teacher: 123,TeacherName: "123", Count: 123, Weekday: 123, Week:123, Name: "123", Type: "123", Location:"123"}\n
// err := ...Add(a) // err == nil если все хорошо
func (ct *ClassTable) Add(c Class) error {
	// Проверяем были ли переданы данные в c
	if c.isDefault() {
		return errors.New("Class.Add: wrong data! provided *Class is empty")
	}

	_, err := ct.db.Exec(`INSERT INTO Classes (class_group_ids, class_group_names, class_teacher_id, class_teacher_name, count, weekday, week, class_name, class_type, class_location)
		SELECT $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
		WHERE NOT EXISTS (
			SELECT 1 FROM classes
			WHERE class_name = $8
			AND weekday = $6
			AND week = $7
			AND class_type = $9
			AND count = $5
			AND class_location = $10
		)`,
		pq.Array(c.Groups), pq.Array(c.GroupsNames), c.Teacher, c.TeacherName, c.Count, c.Weekday, c.Week, c.Name, c.Type, c.Location)

	if err != nil {
		return fmt.Errorf("Class.Add: %v", err)
	}

	return nil
}

// GetById получает данные о паре из базы данных по её Id.
// Принимает Class с непустым полем Id\n
// Возвращает заполненный *Class, nil при успешном получении.
//
// Прим:\n
// a := &Class{Id: 123}\n
// cl, err := ...GetById(a) // err == nil если все хорошо
func (ct *ClassTable) GetById(c Class) (*Class, error) {
	// Проверяем были ли переданы данные в с
	if c.Id == 0 {
		return nil, errors.New("Class.GetById: wrong data! provided *Class is empty")
	}

	row := ct.db.QueryRow(`SELECT class_group_names, class_teacher_id, class_teacher_name, count, weekday, week, class_name, class_type, class_location
		FROM classes
		WHERE class_id = $1`,
		c.Id)

	err := row.Scan(pq.Array(&c.GroupsNames), &c.Teacher, &c.TeacherName, &c.Count, &c.Weekday, &c.Week, &c.Name, &c.Type, &c.Location)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("Class.GetById: %v", err)
	}

	return &c, nil
}

//	СКОРО БУДЕТ УДАЛЕНО, ИСПОЛЬЗУЙТЕ GetForTeacher вместо этого, за доп. функционалом обращаться в канал бд
//
// GetForWeekByTeacher получает данные парах для преподавателя на конкретную неделю из базы данных.
// Принимает Class с непустыми полями Id,Week\n
// Возвращает слайс заполненных *Class, nil при успешном получении.
//
// Прим:\n
// a := Class{Id: 123, Week:123}\n
// cls, err := ...GetById(a) // err == nil если все хорошо
func (ct *ClassTable) GetForWeekByTeacher(c Class) (*[]Class, error) {
	if c.isDefault() {
		return nil, errors.New("Class.GetForWeekByTeacher: wrong data! provided *Class is empty")
	}

	rows, err := ct.db.Query(`SELECT class_id,  class_group_names, class_teacher_name, count, weekday, class_name, class_type, class_location
		FROM classes
		WHERE class_teacher_id = $1 AND week = $2`,
		c.Id, c.Week)
	if err != nil {
		return nil, fmt.Errorf("Class.GetForWeekByTeacher: %v", err)
	}
	defer rows.Close()

	var resultClasses []Class
	for rows.Next() {
		var resultClass Class
		err := rows.Scan(&resultClass.Id, pq.Array(&resultClass.GroupsNames), &resultClass.TeacherName, &resultClass.Count, &resultClass.Weekday, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		if err != nil {
			return nil, fmt.Errorf("Class.GetForWeekByTeacher: %v", err)
		}
		resultClass.Teacher, resultClass.Week = c.Teacher, c.Week
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

func (ct *ClassTable) GetForTeacher(c Class) (*[]Class, error) {
	if c.isDefault() {
		return nil, errors.New("Class.GetForTeacher: wrong data! provided *Class is empty")
	}

	rows, err := ct.db.Query(`SELECT class_id,  class_group_names, count ,week, weekday, class_name, class_type, class_location
		FROM classes
		WHERE class_teacher_name = $1`,
		c.TeacherName)
	if err != nil {
		return nil, fmt.Errorf("Class.GetForTeacher: %v", err)
	}
	defer rows.Close()

	var resultClasses []Class
	for rows.Next() {
		var resultClass Class
		err := rows.Scan(&resultClass.Id, pq.Array(&resultClass.GroupsNames), &resultClass.Count, &resultClass.Week, &resultClass.Weekday, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		if err != nil {
			return nil, fmt.Errorf("Class.GetForTeacher: %v", err)
		}
		resultClass.Teacher, resultClass.Week = c.Teacher, c.Week
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

// GetForDayByTeacher получает данные парах для преподавателя на конкретную неделю из базы данных.
// Принимает Class с непустыми полями Id,Week,Weekday\n
// Возвращает слайс заполненных *Class, nil при успешном получении.
//
// Прим:\n
// a := Class{Id: 123, Week:123,Weekday:123}\n
// cls, err := ...GetById(a) // err == nil если все хорошо
func (ct *ClassTable) GetForDayByTeacher(c Class) (*[]Class, error) {
	if c.isDefault() {
		return nil, errors.New("Class.GetById: wrong data! provided *Class is empty")
	}

	rows, err := ct.db.Query(`SELECT class_id, class_group_names, class_teacher_name, count, class_name, class_type, class_location
		FROM classes
		WHERE class_teacher_id = $1 AND week = $2 AND weekday = $3`,
		c.Id, c.Week, c.Weekday)
	if err != nil {
		return nil, fmt.Errorf("Class.GetById: %v", err)
	}
	defer rows.Close()

	var resultClasses []Class
	for rows.Next() {
		var resultClass Class
		err := rows.Scan(&resultClass.Id, pq.Array(&resultClass.GroupsNames), &resultClass.TeacherName, &resultClass.Count, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		if err != nil {
			return nil, fmt.Errorf("Class.GetById: %v", err)
		}
		resultClass.Teacher, resultClass.TeacherName, resultClass.Week, resultClass.Weekday = c.Teacher, c.TeacherName, c.Week, c.Weekday
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

// GetByLocation возвращает список классов по указанному местоположению.
// Принимает Class (c), содержащий местоположение класса (c.Location).
// Возвращает указатель на срез объектов Class и ошибку при её возникновении.
//
// Прим:
// classes, err := ct.GetByLocation(Class{Location: "A101"})
//
//	if err != nil {
//	    // Обработка ошибки
//	}
//
//	for _, class := range *classes {
//	    // Обработка классов
//	}
func (ct *ClassTable) GetByLocation(c Class) (*[]Class, error) {
	// Проверяем, что переданный объект класса не пустой
	if c.Location == "" {
		return nil, errors.New("Class.GetByLocation: wrong data! provided *Class is empty")
	}

	// Выполняем SQL-запрос для выборки классов по местоположению
	rows, err := ct.db.Query(`SELECT class_id, class_group_names, class_teacher_id, class_teacher_name, count, class_name, class_type
		FROM classes
		WHERE class_location = $1`, c.Location)
	if err != nil {
		return nil, fmt.Errorf("Class.GetByLocation: %v", err)
	}
	defer rows.Close()

	var resultClasses []Class
	for rows.Next() {
		var resultClass Class
		err := rows.Scan(&resultClass.Id, pq.Array(&resultClass.GroupsNames), &resultClass.Teacher, &resultClass.TeacherName, &resultClass.Count, &resultClass.Name, &resultClass.Type)
		if err != nil {
			return nil, fmt.Errorf("Class.GetByLocation: %v", err)
		}

		resultClass.Location = c.Location
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

// Delete удаляет класс из базы данных по указанному идентификатору класса.
// Принимает Class (c), содержащий идентификатор класса (c.Id).
// Возвращает ошибку при её возникновении.
//
// Прим:
// err := ct.Delete(Class{Id: 123})
//
//	if err != nil {
//	    // Обработка ошибки
//	}
func (ct *ClassTable) Delete(c Class) error {
	// Проверяем, что переданный объект класса не пустой
	if c.isDefault() {
		return errors.New("Class.Delete: wrong data! provided *Class is empty")
	}

	// Выполняем SQL-запрос для удаления класса по его идентификатору
	_, err := ct.db.Exec("DELETE FROM classes WHERE class_id = $1", c.Id)
	if err != nil {
		return fmt.Errorf("Class.Delete: %v", err)
	}

	return nil
}

// Функция создания новой таблицы учебных пар
func newClassesTable(db *sql.DB, query string) (*ClassTable, error) {
	_, err := db.Exec(query)
	if err != nil {
		return nil, fmt.Errorf("failed to create classes table: %v", err)
	}
	return &ClassTable{db: db}, nil
}
