package handler

import (
	"iqj/api/excelparser"
	"iqj/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Получает criterion (group, tutor, classroom) и value из запроса, вызывает функцию Parse,
// которая вернет массив с расписанием по заданным критериям.
// Выдает расписание пользователю в формате JSON.
// Например при "GET /lessons?criterion=group&value=ЭФБО-01-23" вернет расписание на неделю группы ЭФБО-01-23.
// при "GET /lessons?criterion=tutor&value=Сафронов А.А." вернет расписание на неделю преподавателя Сафронов А.А.
// при "GET /lessons?criterion=classroom&value=ауд. А-61 (МП-1)" вернет расписание на неделю аудитории ауд. А-61 (МП-1)
// При неверном критерии или значении отправит null

func Lessons(c *gin.Context) {
	criterion := c.Query("criterion")
	value := c.Query("value")

	lessons, err := excelparser.Parse2(criterion, value)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	var filteredLessons []models.Lesson
	for _, lesson := range lessons {
		switch criterion {
		case "group":
			for _, group := range lesson.GroupID {
				if group == 0 { //ЗАМЕНИТЬ НА  group == value
					filteredLessons = append(filteredLessons, lesson)
				}
			}

		case "tutor":
			if lesson.TeacherID == 0 { //ЗАМЕНИТЬ НА lesson.TeacherID == value
				filteredLessons = append(filteredLessons, lesson)
			}

		case "classroom":
			if lesson.Location == value {
				filteredLessons = append(filteredLessons, lesson)
			}
		default:
			c.String(http.StatusBadRequest, err.Error())
			return
		}
	}

	c.JSON(http.StatusOK, filteredLessons)
}
