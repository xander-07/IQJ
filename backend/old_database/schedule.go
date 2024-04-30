package database

//
//import (
//	"iqj/models"
//
//	"github.com/lib/pq"
//)
//
//func (st *Storage) AddLesson(lesson models.Lesson) error {
//	st.Mutex.Lock()
//	defer st.Mutex.Unlock()
//
//	_, err := st.Db.Exec("INSERT INTO schedule"+
//		" (group_id,teacher_id,count,weekday,week,lesson_name,lesson_type,location)"+
//		" VALUES ($1,$2,$3,$4,$5,$6,$7,$8)",
//		pq.Array(lesson.GroupID),
//		lesson.TeacherID,
//		lesson.Count,
//		lesson.Weekday,
//		lesson.Week,
//		lesson.LessonName,
//		lesson.LessonType,
//		lesson.Location,
//	)
//
//	if err != nil {
//		return err
//	}
//
//	return nil
//}
//
//func (st *Storage) GetLessonByID(lesson *models.Lesson) (*models.Lesson, error) {
//	st.Mutex.Lock()
//	defer st.Mutex.Unlock()
//
//	row := st.Db.QueryRow("SELECT * FROM schedule WHERE id = $1",
//		lesson.Id)
//	err := row.Scan(
//		&lesson.Id,
//		pq.Array(&lesson.GroupID),
//		&lesson.TeacherID,
//		&lesson.Count,
//		&lesson.Weekday,
//		&lesson.Week,
//		&lesson.LessonName,
//		&lesson.LessonType,
//		&lesson.Location)
//	if err != nil {
//		return nil, err
//	}
//	return lesson, nil
//}
//
//func (st *Storage) GetLessonsByTeacherID(lesson *models.Lesson) (*[]models.Lesson, error) {
//	st.Mutex.Lock()
//	defer st.Mutex.Unlock()
//
//	rows, err := st.Db.Query("SELECT * FROM schedule WHERE teacher_id = $1",
//		lesson.TeacherID)
//
//	var lessons []models.Lesson
//
//	for rows.Next() {
//		var id, teacherID, count, weekday, week int
//		var lessonName, lessonType, location string
//		var groupID []int
//
//		err = rows.Scan(
//			&id,
//			pq.Array(&lesson.GroupID),
//			&teacherID,
//			&count,
//			&weekday,
//			&week,
//			&lessonName,
//			&lessonType,
//			&location)
//		if err != nil {
//			return nil, err
//		}
//
//		resultingLesson := models.Lesson{
//			Id:         id,
//			GroupID:    groupID,
//			TeacherID:  teacherID,
//			Count:      count,
//			Weekday:    weekday,
//			Week:       week,
//			LessonName: lessonName,
//			LessonType: lessonType,
//			Location:   location,
//		}
//		lessons = append(lessons, resultingLesson)
//	}
//
//	return &lessons, nil
//}
//
//func (st *Storage) GetLessonsByGroupID(selectedGroupId int) (*[]models.Lesson, error) {
//	st.Mutex.Lock()
//	defer st.Mutex.Unlock()
//
//	rows, err := st.Db.Query("SELECT * FROM schedule WHERE $1 = ANY(group_id)",
//		selectedGroupId)
//
//	var lessons []models.Lesson
//
//	for rows.Next() {
//		var id, teacherID, count, weekday, week int
//		var lessonName, lessonType, location string
//		var groupID []int
//
//		err = rows.Scan(
//			&id,
//			pq.Array(&groupID),
//			&teacherID,
//			&count,
//			&weekday,
//			&week,
//			&lessonName,
//			&lessonType,
//			&location)
//		if err != nil {
//			return nil, err
//		}
//
//		resultingLesson := models.Lesson{
//			Id:         id,
//			GroupID:    groupID,
//			TeacherID:  teacherID,
//			Count:      count,
//			Weekday:    weekday,
//			Week:       week,
//			LessonName: lessonName,
//			LessonType: lessonType,
//			Location:   location,
//		}
//		lessons = append(lessons, resultingLesson)
//	}
//
//	return &lessons, nil
//}
//
//func (st *Storage) GetLessonsByLocation(location string) (*[]models.Lesson, error) {
//	st.Mutex.Lock()
//	defer st.Mutex.Unlock()
//
//	rows, err := st.Db.Query("SELECT * FROM schedule WHERE location = $1",
//		location)
//
//	var lessons []models.Lesson
//
//	for rows.Next() {
//		var id, teacherID, count, weekday, week int
//		var lessonName, lessonType, location string
//		var groupID []int
//
//		err = rows.Scan(
//			&id,
//			pq.Array(&groupID),
//			&teacherID,
//			&count,
//			&weekday,
//			&week,
//			&lessonName,
//			&lessonType,
//			&location)
//		if err != nil {
//			return nil, err
//		}
//
//		resultingLesson := models.Lesson{
//			Id:         id,
//			GroupID:    groupID,
//			TeacherID:  teacherID,
//			Count:      count,
//			Weekday:    weekday,
//			Week:       week,
//			LessonName: lessonName,
//			LessonType: lessonType,
//			Location:   location,
//		}
//		lessons = append(lessons, resultingLesson)
//	}
//
//	return &lessons, nil
//}
