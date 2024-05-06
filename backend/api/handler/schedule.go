package handler

import (
	"github.com/gin-gonic/gin"
	"github.com/patrickmn/go-cache"
	"iqj/api/excelparser"
	"net/http"
	"time"
)

// Получает criterion (group, tutor, classroom) и value из запроса, вызывает функцию Parse,
// которая вернет массив с расписанием по заданным критериям.
// Выдает расписание пользователю в формате JSON.
// Например при "GET /lessons?criterion=group&value=ЭФБО-01-23" вернет расписание на неделю группы ЭФБО-01-23.
// при "GET /lessons?criterion=tutor&value=Сафронов А.А." вернет расписание на неделю преподавателя Сафронов А.А.
// при "GET /lessons?criterion=classroom&value=ауд. А-61 (МП-1)" вернет расписание на неделю аудитории ауд. А-61 (МП-1)
// При неверном критерии или значении отправит null

var Cache2 *cache.Cache

func InitCache() {
	Cache2 = cache.New(168*time.Hour, 336*time.Hour)
}

func (h *Handler) Lessons(c *gin.Context) {
	criterion := c.Query("criterion")
	value := c.Query("value")
	item, found := Cache2.Get(value)
	if found {
		c.JSON(http.StatusOK, item.([]excelparser.Lesson))
		return
	} else {
		lessons, err := excelparser.Parse2(criterion, value)
		if err != nil {
			c.String(http.StatusBadRequest, err.Error())
			return
		}

		var filteredLessons []excelparser.Lesson
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

		Cache2.Set(value, filteredLessons, cache.DefaultExpiration)

		c.JSON(http.StatusOK, filteredLessons)
	}
}
