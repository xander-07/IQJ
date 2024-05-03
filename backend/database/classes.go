package database

import (
	"database/sql"
	"errors"
	"fmt"

	"github.com/lib/pq"
)

// Структура учебной пары
type Class struct {
	Id       int    `json:"class_id"`                  // Id пары
	Groups   []int  `json:"class_group_ids,omitempty"` // Список Id групп, для которых пара
	Teacher  int    `json:"class_teacher_id"`          // Id преподавателя, который ведет пару
	TeacherName string `json:"class_teacher_name"`	   // фио преподавателя
	Count    int    `json:"class_count"`               // Какая пара по счету за день
	Weekday  int    `json:"class_weekday"`             // Номер дня недели
	Week     int    `json:"class_week"`                // Номер учебной неделяя
	Name     string `json:"class_name"`                // Название пары
	Type     string `json:"class_type"`                // Тип пары
	Location string `json:"class_location"`            // Местонахождение
}

// Проверяет переданы ли в структуру какие-либо данные
func (c *Class) isDefault() bool {
	return c.Id == 0 && c.Groups == nil && c.Teacher == 0 && c.Count == 0 && c.Weekday == 0 && c.Week == 0 && c.Name == "" && c.Type == "" && c.Location == ""
}

// Структура для взаимодействия с таблицой Classes
type ClassTable struct {
	db *sql.DB    // Указатель на подключение к бд
	qm queryMaker // Исполнитель ОБЫЧНЫХ sql запросов (см. query_maker.go)
}

// Add добавляет данные в базу данных.
// Принимает указатель на Class с непустыми полями Groups, Teacher, Count, Weekday, Week, Name, Type, Location\n
// Возвращает nil при успешном добавлении.
//
// Прим:\n
// a := &Class{Groups: []int{1,2,3}, Teacher: 123,TeacherName: "123", Count: 123, Weekday: 123, Week:123, Name: "123", Type: "123", Location:"123"}\n
// err := ...Add(a) // err == nil если все хорошо
func (ct *ClassTable) Add(c *Class) error {
	// Проверяем были ли переданы данные в c
	if c.isDefault() {
		return errors.New("Class.Add: wrong data! provided *Class is empty")
	}

	// Используем queryMaker для исполнения запроса
	err := ct.qm.makeInsert(ct.db,
		`INSERT INTO Classes (class_group_ids, class_teacher_id, cllass_teacher_name, count, weekday, week, class_name, class_type, class_location)
		SELECT $1, $2, $3, $4, $5, $6, $7, $8, $9
		WHERE NOT EXISTS (
    	SELECT 1 FROM classes
     	WHERE class_name = $7
    	AND weekday = $5
        AND week = $6
        AND class_type = $8
        AND count = $4
        AND class_group_id = $1
        AND class_teacher_id = $2
)`,
pq.Array(&c.Groups), &c.Teacher, &c.TeacherName, &c.Count, &c.Weekday, &c.Week, &c.Name, &c.Type, &c.Location)

	if err != nil {
		return fmt.Errorf("Class.Add: %v", err)
	}

	return nil
}

// GetById получает данные о паре из базы данных по её Id.
// Принимает указатель на Class с непустым полем Id\n
// Возвращает заполненный *Class, nil при успешном получении.
//
// Прим:\n
// a := &Class{Id: 123}\n
// cl, err := ...GetById(a) // err == nil если все хорошо
func (ct *ClassTable) GetById(c *Class) (*Class, error) {
	// Проверяем были ли переданы данные в с
	if c.isDefault() {
		return nil, errors.New("Class.GetById: wrong data! provided *Class is empty")
	}

	// Используем queryMaker для создания и исполнения select запроса
	row, err := ct.qm.makeSelect(ct.db,
		`SELECT class_group_ids, class_teacher_id,	class_teacher_name count, weekday, week, class_name, class_type, сlass_location
FROM classes
WHERE class_id = $1;
`,
		c.Id)
	if err != nil {
		return nil, fmt.Errorf("Class.GetById: %v", err)
	}

	if !row.Next() {
		return nil, nil
	}
	row.Scan(pq.Array(&c.Groups), &c.Teacher,&c.TeacherName, &c.Count, &c.Weekday, &c.Week, &c.Name, &c.Type, &c.Location)

	return c, nil

}

// GetForWeekByTeacher получает данные парах для преподавателя на конкретную неделю из базы данных.
// Принимает указатель на Class с непустыми полями Id,Week\n
// Возвращает слайс заполненных *Class, nil при успешном получении.
//
// Прим:\n
// a := &Class{Id: 123, Week:123}\n
// cls, err := ...GetById(a) // err == nil если все хорошо
func (ct *ClassTable) GetForWeekByTeacher(c *Class) (*[]Class, error) {
	if c.isDefault() {
		return nil, errors.New("Class.GetForWeekByTeacher: wrong data! provided *Class is empty")
	}

	rows, err := ct.qm.makeSelect(ct.db,
		`SELECT class_id, class_group_ids, class_teacher_name, count, weekday, class_name, class_type, class_location
		FROM classes
		WHERE class_teacher_id = $1 AND week = $2;`,
		c.Id, c.Week)
	if err != nil {
		return nil, fmt.Errorf("Class.GetForWeekByTeacher: %v", err)
	}

	var resultClasses []Class
	var resultClass Class

	for rows.Next() {
		rows.Scan(&resultClass.Id, pq.Array(&resultClass.Groups), &resultClass.TeacherName,&resultClass.Count, &resultClass.Weekday, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		resultClass.Teacher, resultClass.Week = c.Teacher, c.Week
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

// GetForWeekByTeacher получает данные парах для преподавателя на конкретную неделю из базы данных.
// Принимает указатель на Class с непустыми полями Id,Week,Weekday\n
// Возвращает слайс заполненных *Class, nil при успешном получении.
//
// Прим:\n
// a := &Class{Id: 123, Week:123,Weekday:123}\n
// cls, err := ...GetById(a) // err == nil если все хорошо
func (ct *ClassTable) GetForDayByTeacher(c *Class) (*[]Class, error) {
	if c.isDefault() {
		return nil, errors.New("Class.GetById: wrong data! provided *Class is empty")
	}

	rows, err := ct.qm.makeSelect(ct.db,
		`SELECT class_id, сlass_group_ids, count, class_name, class_type, class_location
		FROM classes
		WHERE class_teacher_id = $1 AND week = $2 AND weekday = $3;`,
		c.Id, c.Week, c.Weekday)
	if err != nil {
		return nil, fmt.Errorf("Class.GetById: %v", err)
	}

	var resultClasses []Class
	var resultClass Class

	for rows.Next() {
		rows.Scan(&resultClass.Id, pq.Array(&resultClass.Groups),&resultClass.TeacherName, &resultClass.Count, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		resultClass.Teacher, resultClass.TeacherName, resultClass.Week, resultClass.Weekday = c.Teacher, c.TeacherName, c.Week, c.Weekday
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

func (ct *ClassTable) GetByLocation (c *Class) (*[]Class,error){
	if c.isDefault(){
		return nil, errors.New("Class.GetByLocation: wrong data! provided *Class is empty")
	}


	rows, err := ct.qm.makeSelect(ct.db,
		`SELECT class_id, сlass_group_ids, class_teacher_id, class_teacher_name, count, class_name, class_type
		FROM classes
		WHERE class_location = $1;`, c.Location)
	if err != nil {
		return nil, fmt.Errorf("Class.GetById: %v", err)
	}

	var resultClasses []Class
	var resultClass Class

	for rows.Next() {
		rows.Scan(&resultClass.Id, pq.Array(&resultClass.Groups),&resultClass.TeacherName, &resultClass.Count, &resultClass.Name, &resultClass.Type, &resultClass.Location)
		resultClass.Teacher, resultClass.Week, resultClass.Weekday = c.Teacher, c.Week, c.Weekday
		resultClasses = append(resultClasses, resultClass)
	}

	return &resultClasses, nil
}

func (ct *ClassTable) Delete(c *Class) error {
	if c.isDefault() {
		return errors.New("Class.Delete: wrong data! provided *Class is empty")
	}

	err := ct.qm.makeDelete(ct.db,
		"DELETE FROM classes WHERE class_id = $1",
		c.Id)

	if err != nil {
		return fmt.Errorf("Class.Delete: %v", err)
	}

	return nil
}
