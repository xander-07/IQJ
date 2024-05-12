package database

import (
	"database/sql"
	"errors"
	"fmt"

	"github.com/lib/pq"
)

// StudentGroup представляет сущность группы студентов в системе.
type StudentGroup struct {
	Id        int    // Уникальный идентификатор группы
	Grade     int    // Курс группы
	Institute string // Название института
	Name      string // Название группы
	Students  []int  // Идентификаторы студентов в группе
}

// isDefault проверяет, переданы ли какие-либо данные в структуру StudentGroup.
// Необходимо для реализации интерфейса Entity и фильтров в функциях БД.
func (sg *StudentGroup) isDefault() bool {
	return sg.Id == 0 && sg.Grade == 0 && sg.Institute == "" && sg.Name == "" && sg.Students == nil
}

// StudentGroupTable предоставляет методы для работы с таблицей групп студентов в базе данных.
type StudentGroupTable struct {
	db *sql.DB // Указатель на подключение к базе данных
}

// GetByID возвращает группу студентов из базы данных по указанному идентификатору.
func (sgt *StudentGroupTable) GetByID(sg StudentGroup) (*StudentGroup, error) {
	if sg.isDefault() {
		return nil, errors.New("StudentGroup.GetByID: wrong data! provided *StudentGroup is empty!")
	}

	row := sgt.db.QueryRow("SELECT grade, institute, student_group_name, student_group_students_ids FROM students_groups WHERE students_group_id = $1", sg.Id)
	if row.Err() != nil {
		return nil, fmt.Errorf("studentGroupTable.GetByID: %v", row.Err().Error())
	}

	if err := row.Scan(&sg.Grade, &sg.Institute, &sg.Name, pq.Array(&sg.Students)); err != nil {
		return nil, fmt.Errorf("studentGroupTable.GetByID: %v", err)
	}

	return &sg, nil
}

// GetIdByName возвращает идентификатор группы студентов из базы данных по указанному названию группы.
func (sgt *StudentGroupTable) GetIdByName(sg StudentGroup) (*StudentGroup, error) {
	if sg.isDefault() {
		return nil, errors.New("StudentGroup.GetByName: wrong data! provided *StudentGroup is empty!")
	}

	row := sgt.db.QueryRow("SELECT students_group_id FROM student_groups WHERE student_group_name = $1", sg.Name)
	if err := row.Scan(&sg.Id); err != nil {
		return nil, fmt.Errorf("StudentGroup.GetByName: %v", err)
	}

	return &sg, nil
}

// GetStudent возвращает группу студентов из базы данных по указанному идентификатору студента.
func (sgt *StudentGroupTable) GetStudent(sg StudentGroup) (*StudentGroup, error) {
	if sg.isDefault() {
		return nil, errors.New("StudentGroup.GetStudent: wrong data! provided *StudentGroup is empty!")
	}

	row := sgt.db.QueryRow("SELECT sg.grade, sg.institute, sg.student_group_name, sg.student_group_students_ids FROM students_groups sg JOIN students s ON sg.students_group_id = s.student_group_id WHERE s.student_id = $1", sg.Id)
	if row.Err() != nil {
		return nil, fmt.Errorf("studentGroupTable.GetStudent: %v", row.Err().Error())
	}

	if err := row.Scan(&sg.Grade, &sg.Institute, &sg.Name, pq.Array(&sg.Students)); err != nil {
		return nil, fmt.Errorf("studentGroupTable.GetStudent: %v", err)
	}

	return &sg, nil
}

// GetGroupsByInstituteAndGrade возвращает группы студентов из базы данных по названию института и курсу.
func (sgt *StudentGroupTable) GetGroupsByInstituteAndGrade(institute string, grade int) ([]*StudentGroup, error) {
	groups := []*StudentGroup{}

	rows, err := sgt.db.Query("SELECT students_group_id, student_group_name, student_group_students_ids FROM students_groups WHERE institute = $1 AND grade = $2", institute, grade)
	if err != nil {
		return nil, fmt.Errorf("studentGroupTable.GetGroupsByInstituteAndGrade: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		group := &StudentGroup{}
		if err := rows.Scan(&group.Id, &group.Name, pq.Array(&group.Students)); err != nil {
			return nil, fmt.Errorf("studentGroupTable.GetGroupsByInstituteAndGrade: %v", err)
		}
		groups = append(groups, group)
	}

	return groups, nil
}

// GetGroupsByInstitute возвращает группы студентов из базы данных по названию института.
func (sgt *StudentGroupTable) GetGroupsByInstitute(sg StudentGroup) ([]*StudentGroup, error) {
	groups := []*StudentGroup{}

	rows, err := sgt.db.Query("SELECT students_group_id, student_group_name, student_group_students_ids FROM students_groups WHERE institute = $1", sg.Institute)
	if err != nil {
		return nil, fmt.Errorf("studentGroupTable.GetGroupsByInstitute: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		group := &StudentGroup{}
		if err := rows.Scan(&group.Id, &group.Name, pq.Array(&group.Students)); err != nil {
			return nil, fmt.Errorf("studentGroupTable.GetGroupsByInstitute: %v", err)
		}
		groups = append(groups, group)
	}

	return groups, nil
}

// GetGroupsByGrade возвращает группы студентов из базы данных по номеру курса.
func (sgt *StudentGroupTable) GetGroupsByGrade(sg StudentGroup) ([]*StudentGroup, error) {
	groups := []*StudentGroup{}

	rows, err := sgt.db.Query("SELECT students_group_id, student_group_name, student_group_students_ids FROM students_groups WHERE grade = $1", sg.Grade)
	if err != nil {
		return nil, fmt.Errorf("studentGroupTable.GetGroupsByGrade: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		group := &StudentGroup{}
		if err := rows.Scan(&group.Id, &group.Name, pq.Array(&group.Students)); err != nil {
			return nil, fmt.Errorf("studentGroupTable.GetGroupsByGrade: %v", err)
		}
		groups = append(groups, group)
	}

	return groups, nil
}

// Add добавляет группу студентов в базу данных.
func (sgt *StudentGroupTable) Add(group StudentGroup) error {
	if group.isDefault() {
		return errors.New("studentGroupTable.Add: wrong data! provided *StudentGroup is empty")
	}

	_, err := sgt.db.Exec("INSERT INTO students_groups (grade, institute, student_group_name, student_group_students_ids) VALUES ($1, $2, $3, $4)", group.Grade, group.Institute, group.Name, pq.Array(&group.Students))
	if err != nil {
		return fmt.Errorf("studentGroupTable.Add: %v", err)
	}

	return nil
}

// Update обновляет данные о группе студентов в базе данных.
func (sgt *StudentGroupTable) Update(sg StudentGroup) error {
	if sg.isDefault() {
		return errors.New("StudentGroup.Update: wrong data! provided *StudentGroup is empty")
	}

	_, err := sgt.db.Exec("UPDATE students_groups SET grade = $1, institute = $2, student_group_name = $3, student_group_students_ids = $4 WHERE students_group_id = $5", sg.Grade, sg.Institute, sg.Name, pq.Array(&sg.Students), sg.Id)
	if err != nil {
		return fmt.Errorf("StudentGroup.Update: %v", err)
	}

	return nil
}

// GetClasses возвращает классы для группы студентов из базы данных.
func (sgt *StudentGroupTable) GetClassesById(sg StudentGroup) (*[]Class, error) {
	if sg.isDefault() {
		return nil, errors.New("StudentGroup.GetClasses: wrong data! provided *StudentGroup is empty")
	}

	rows, err := sgt.db.Query("SELECT class_id, class_teacher_id, class_teacher_name, count, week, weekday, class_name, class_type, class_location, class_group_names FROM classes WHERE $1 = ANY(class_group_ids)", sg.Id)
	if err != nil {
		return nil, fmt.Errorf("StudentGroup.GetClasses: %v", err)
	}
	defer rows.Close()

	var resultClasses []Class
	for rows.Next() {
		var resultClass Class
		if err := rows.Scan(&resultClass.Id, &resultClass.Teacher, &resultClass.TeacherName, &resultClass.Count, &resultClass.Week, &resultClass.Weekday, &resultClass.Name, &resultClass.Type, &resultClass.Location, pq.Array(&resultClass.GroupsNames)); err != nil {
			return nil, fmt.Errorf("StudentGroup.GetClasses: error scanning row: %v", err)
		}
		resultClasses = append(resultClasses, resultClass)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("StudentGroup.GetClasses: error after scanning rows: %v", err)
	}

	return &resultClasses, nil
}

// GetClasses возвращает классы для группы студентов из базы данных.
func (sgt *StudentGroupTable) GetClassesByName(sg StudentGroup) (*[]Class, error) {
	if sg.isDefault() {
		return nil, errors.New("StudentGroup.GetClasses: wrong data! provided *StudentGroup is empty")
	}

	rows, err := sgt.db.Query("SELECT class_id, class_teacher_id, class_teacher_name, count, week, weekday, class_name, class_type, class_location FROM classes WHERE $1 = ANY(class_group_names)", sg.Name)
	if err != nil {
		return nil, fmt.Errorf("StudentGroup.GetClasses: %v", err)
	}
	defer rows.Close()

	var resultClasses []Class
	for rows.Next() {
		var resultClass Class
		if err := rows.Scan(&resultClass.Id, &resultClass.Teacher, &resultClass.TeacherName, &resultClass.Count, &resultClass.Week, &resultClass.Weekday, &resultClass.Name, &resultClass.Type, &resultClass.Location); err != nil {
			return nil, fmt.Errorf("StudentGroup.GetClasses: error scanning row: %v", err)
		}
		resultClass.Name = sg.Name
		resultClasses = append(resultClasses, resultClass)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("StudentGroup.GetClasses: error after scanning rows: %v", err)
	}

	return &resultClasses, nil
}

// Delete удаляет группу студентов из базы данных по указанному идентификатору.
func (sgt *StudentGroupTable) Delete(sg StudentGroup) error {
	_, err := sgt.db.Exec("DELETE FROM students_groups WHERE students_group_id = $1", sg.Id)
	if err != nil {
		return fmt.Errorf("studentGroupTable.Delete: %v", err)
	}

	return nil
}

func newStudentGroupTable(db *sql.DB, query string) (*StudentGroupTable, error) {
	_, err := db.Exec(query)
	if err != nil {
		return nil, fmt.Errorf("failed to create student_groups table: %v", err)
	}

	return &StudentGroupTable{db: db}, nil
}
