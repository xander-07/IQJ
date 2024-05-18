package database

import (
	"database/sql"
	"errors"
	"fmt"
	dbUtils "iqj/pkg/utils"

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
	if sg.isDefault() { // проверяем пустая ли структура передана
		return nil, errors.New("StudentGroup.GetByID: wrong data! provided *StudentGroup is empty!")
	}

	// выполняем sql запрос, возвращающий лишь один *sql.Row
	row := sgt.db.QueryRow("SELECT grade, institute, student_group_name, student_group_students_ids FROM students_groups WHERE students_group_id = $1", sg.Id)
	if row.Err() != nil { // обрабатываем ошибку, которая может возникнуть при выполнении
		return nil, fmt.Errorf("studentGroupTable.GetByID: %v", row.Err().Error())
	}

	// сканируем наш row, попутно проверяя есть ли в нем ошибка
	if err := row.Scan(&sg.Grade, &sg.Institute, &sg.Name, pq.Array(&sg.Students)); err != nil {
		return nil, fmt.Errorf("studentGroupTable.GetByID: %v", err)
	}

	// возвращаем указатель на полученные данные
	return &sg, nil
}

// GetIdByName возвращает идентификатор группы студентов из базы данных по указанному названию группы.
func (sgt *StudentGroupTable) GetIdByName(sg StudentGroup) (*StudentGroup, error) {
	if sg.isDefault() { // проверяем переданы ли данные в полученную структуру
		return nil, errors.New("StudentGroup.GetByName: wrong data! provided *StudentGroup is empty!")
	}

	// выполняем sql запрос, возвращающий лишь один *sql.Row
	row := sgt.db.QueryRow("SELECT students_group_id FROM student_groups WHERE student_group_name = $1", sg.Name)
	if err := row.Scan(&sg.Id); err != nil { // сканируем из полученного ряда айди
		// проверяем является полученная ошибка ошибкой пустого возврата
		if errors.Is(err, sql.ErrNoRows) {
			// ошибка, которая будет выводиться, если такой группы нет, необходима обработка
			return nil, sql.ErrNoRows
		} // если что то другое, то возвращаем ошибку
		return nil, fmt.Errorf("StudentGroup.GetByName: %v", err)
	}

	return &sg, nil
}

// GetStudent возвращает группу студентов из базы данных по указанному идентификатору студента.
func (sgt *StudentGroupTable) GetStudent(sg StudentGroup) (*StudentGroup, error) {
	if sg.isDefault() { // проверяем является ли структура пустой
		return nil, errors.New("StudentGroup.GetStudent: wrong data! provided *StudentGroup is empty!")
	}

	// выполняем sql запрос, возвращающий лишь один *sql.Row
	row := sgt.db.QueryRow("SELECT sg.grade, sg.institute, sg.student_group_name, sg.student_group_students_ids FROM students_groups sg JOIN students s ON sg.students_group_id = s.student_group_id WHERE s.student_id = $1", sg.Id)
	if row.Err() != nil {
		return nil, fmt.Errorf("studentGroupTable.GetStudent: %v", row.Err().Error())
	}

	// сканируем данные в структуру для возврата, попутно проверяя ошибку
	if err := row.Scan(&sg.Grade, &sg.Institute, &sg.Name, pq.Array(&sg.Students)); err != nil {
		return nil, fmt.Errorf("studentGroupTable.GetStudent: %v", err)
	}

	return &sg, nil
}

// GetGroupsByInstituteAndGrade возвращает группы студентов из базы данных по названию института и курсу.
func (sgt *StudentGroupTable) GetGroupsByInstituteAndGrade(institute string, grade int) (*[]StudentGroup, error) {
	groups := []StudentGroup{} // создаем массив, который после будем возвращать

	// выполняем запрос, из рядов которого после будем вытаскивать данные в groups
	rows, err := sgt.db.Query("SELECT students_group_id, student_group_name, student_group_students_ids FROM students_groups WHERE institute = $1 AND grade = $2", institute, grade)
	if err != nil {
		return nil, fmt.Errorf("studentGroupTable.GetGroupsByInstituteAndGrade: %v", err)
	}
	defer rows.Close() // закрываем ряды, чтобы не было утечек и какого-либо непредсказуемого поведения

	for rows.Next() { // проходимся по всем рядам
		group := StudentGroup{} // пустая структура, клонами которой, после заполнения, будем заполнять groups

		// вытаскиваем данные, попутно проверяя ошибку
		if err := rows.Scan(&group.Id, &group.Name, pq.Array(&group.Students)); err != nil {
			return nil, fmt.Errorf("studentGroupTable.GetGroupsByInstituteAndGrade: %v", err)
		}
		groups = append(groups, group)
	}

	return &groups, nil
}

// GetGroupsByInstitute возвращает группы студентов из базы данных по названию института.
func (sgt *StudentGroupTable) GetGroupsByInstitute(sg StudentGroup) (*[]StudentGroup, error) {

	// тут все то же самое, что и в GetGroupsByInstituteAndGrade

	groups := []StudentGroup{} // создаем массив групп, который после вернем

	// получаем ряды с данными из бд
	rows, err := sgt.db.Query("SELECT students_group_id, student_group_name, student_group_students_ids FROM students_groups WHERE institute = $1", sg.Institute)
	if err != nil {
		return nil, fmt.Errorf("studentGroupTable.GetGroupsByInstitute: %v", err)
	}
	defer rows.Close() // закрываем ряды

	for rows.Next() {
		group := StudentGroup{}
		if err := rows.Scan(&group.Id, &group.Name, pq.Array(&group.Students)); err != nil {
			return nil, fmt.Errorf("studentGroupTable.GetGroupsByInstitute: %v", err)
		}
		groups = append(groups, group)
	}

	return &groups, nil
}

// GetGroupsByGrade возвращает группы студентов из базы данных по номеру курса.
func (sgt *StudentGroupTable) GetGroupsByGrade(sg StudentGroup) ([]*StudentGroup, error) {

	// опять же все то же самое

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
	if sg.isDefault() { // проверяем переданную структуру
		return nil, errors.New("StudentGroup.GetClassesById: wrong data! provided *StudentGroup is empty")
	}

	// вытаскиваем ряды с данными из бд
	rows, err := sgt.db.Query(
		"SELECT class_id, class_group_ids, class_group_names, class_teacher_id, class_teacher_name, count, week, weekday, class_name, class_type, class_location FROM classes WHERE $1 = ANY(class_group_ids)",
		sg.Id)

	if err != nil {
		return nil, fmt.Errorf("StudentGroup.GetClassesById: %v", err)
	}
	defer func() {
		if cerr := rows.Close(); cerr != nil {
			err = fmt.Errorf("StudentGroup.GetClassesById: error closing rows: %v", cerr)
		}
	}()

	var resultClasses []Class // создаем массив, который после будем возвращать
	for rows.Next() {
		var resultClass Class

		// создаем массив, который бд-драйвер сможет заполнить, так как он не умеет работать с []int
		idsArr := pq.Int32Array{}

		if err := rows.Scan(&resultClass.Id, &idsArr, pq.Array(&resultClass.GroupsNames), &resultClass.Teacher, &resultClass.TeacherName, &resultClass.Count, &resultClass.Week, &resultClass.Weekday, &resultClass.Name, &resultClass.Type, &resultClass.Location); err != nil {
			return nil, fmt.Errorf("StudentGroup.GetClassesById: error scanning row: %v", err)
		}

		// с помощью функции из utils преобразовываем массив из []int32 в []int, который используется в нашей структуре
		resultClass.Groups = dbUtils.ConvertIntegerSlice[int32, int](idsArr)

		resultClasses = append(resultClasses, resultClass)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("StudentGroup.GetClassesById: error after scanning rows: %v", err)
	}

	return &resultClasses, nil
}

// GetClasses возвращает классы для группы студентов из базы данных.
func (sgt *StudentGroupTable) GetClassesByName(sg StudentGroup) (*[]Class, error) {

	// все то же самое, что и в функции выше

	if sg.isDefault() { // проверяем данные в структуре
		return nil, errors.New("StudentGroup.GetClassesByName: wrong data! provided *StudentGroup is empty")
	}

	// достаем ряды
	rows, err := sgt.db.Query("SELECT class_id, class_group_ids, class_group_names, class_teacher_id, class_teacher_name, count, week, weekday, class_name, class_type, class_location FROM classes WHERE $1 = ANY(class_group_names)", sg.Name)
	if err != nil {
		return nil, fmt.Errorf("StudentGroup.GetClassesByName: %v", err)
	}
	defer func() {
		if cerr := rows.Close(); cerr != nil {
			err = fmt.Errorf("StudentGroup.GetClasses: error closing rows: %v", cerr)
		}
	}()

	var resultClasses []Class
	for rows.Next() {
		var resultClass Class

		idsArr := pq.Int32Array{} // опять мучаемся с типами

		if err := rows.Scan(&resultClass.Id, &idsArr, pq.Array(&resultClass.GroupsNames), &resultClass.Teacher, &resultClass.TeacherName, &resultClass.Count, &resultClass.Week, &resultClass.Weekday, &resultClass.Name, &resultClass.Type, &resultClass.Location); err != nil {
			return nil, fmt.Errorf("StudentGroup.GetClassesById: error scanning row: %v", err)
		}
		resultClass.Groups = dbUtils.ConvertIntegerSlice[int32, int](idsArr) // конвертируем в тип, который можем использовать
		resultClasses = append(resultClasses, resultClass)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("StudentGroup.GetClassesByName: error after scanning rows: %v", err)
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
