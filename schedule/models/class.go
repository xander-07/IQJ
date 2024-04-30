package models

type Lesson struct {
	Id         int    `json:"class_id"`                  // Id пары
	GroupID    []int  `json:"class_group_ids,omitempty"` // ЗАМЕНИТЬ НА []string //Список Id групп, для которых пара
	TeacherID  int    `json:"class_teacher_id"`          // ЗАМЕНИТЬ НА string //Id преподавателя, который ведет пару
	Count      int    `json:"class_count"`               // Какая пара по счету за день
	Weekday    int    `json:"class_weekday"`             // Номер дня недели
	Week       int    `json:"class_week"`                // Номер учебной неделяя
	LessonName string `json:"class_name"`                // Название пары
	LessonType string `json:"class_type"`                // Тип пары
	Location   string `json:"class_location"`            // Местонахождение
}
