package handler

import (
	"github.com/gin-gonic/gin"
	cache2 "iqj/pkg/cache"
	"iqj/pkg/excel_parser"
	"net/http"
)

// Получает criterion (group, tutor, classroom) и value из запроса, вызывает функцию Parse,
// которая вернет массив с расписанием по заданным критериям.
// Выдает расписание пользователю в формате JSON.
// Например при "GET /lessons?criterion=group&value=ЭФБО-01-23" вернет расписание на неделю группы ЭФБО-01-23.
// при "GET /lessons?criterion=tutor&value=Сафронов А.А." вернет расписание на неделю преподавателя Сафронов А.А.
// при "GET /lessons?criterion=classroom&value=ауд. А-61 (МП-1)" вернет расписание на неделю аудитории ауд. А-61 (МП-1)
// При неверном критерии или значении отправит null

var cache = cache2.NewLFUCache(100)

func (h *Handler) Lessons(c *gin.Context) {
	criterion := c.Query("criterion")
	value := c.Query("value")

	item := cache.Get(value)
	if item != nil {
		c.JSON(http.StatusOK, item)
	} else {
		lessons, err := excel_parser.Parse2(criterion, value)
		if err != nil {
			c.String(http.StatusBadRequest, err.Error())
			return
		}

		var filteredLessons []excel_parser.Lesson
		for _, lesson := range lessons {
			switch criterion {
			case "group":
				for _, group := range lesson.GroupID {
					if group == value { //ЗАМЕНИТЬ НА  group == value
						filteredLessons = append(filteredLessons, lesson)
					}
				}

			case "tutor":
				if lesson.TeacherID == value { //ЗАМЕНИТЬ НА lesson.TeacherID == value
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

		cache.Set(value, filteredLessons)

		c.JSON(http.StatusOK, filteredLessons)
	}
}
