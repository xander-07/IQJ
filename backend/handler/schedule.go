package handler

import (
	"iqj/api/excelparser"
	"iqj/database"
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

func (h *Handler) Lessons(c *gin.Context) {
	criterion := c.Query("criterion")
	value := c.Query("value")

	err := excelparser.Parse2()
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	lesson := &database.Class{}
	filteredLessons := &[]database.Class{}

	switch criterion {
	case "group":
		/*group := database.Database.Class.getIdByName(value)
		lesson.Groups = append(lesson.Groups, group)
		filteredLessons, err = database.Database.Class.GetByGroup(lesson)
		if err != nil {
			c.String(http.StatusBadRequest, err.Error())
		}*/

	case "tutor":
		lesson.TeacherName = value
		filteredLessons, err = database.Database.Class.GetForWeekByTeacher(lesson)
		if err != nil {
			c.String(http.StatusBadRequest, err.Error())
		}

	case "classroom":
		lesson.Location = value
		filteredLessons, err = database.Database.Class.GetByLocation(lesson)
		if err != nil {
			c.String(http.StatusBadRequest, err.Error())
		}
	default:
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	c.JSON(http.StatusOK, filteredLessons)
}
