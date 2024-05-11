package handler

import (
	"iqj/internal/database"
	cachepkg "iqj/pkg/cache"
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

// Использование кэша
var cache = cachepkg.NewLFUCache(100)

func (h *Handler) Lessons(c *gin.Context) {
	//Получение в criterion и value заданных значений
	criterion := c.Query("criterion")
	value := c.Query("value")

	lesson := &database.Class{}
	filteredLessons := &[]database.Class{}

	//Проверяем, есть ли заданное значение в кэше
	item := cache.Get(value)
	if item != nil { //Если есть, возвращаем его
		c.JSON(http.StatusOK, item)
	} else {

		var err error

		//Switch по заданному критерию
		switch criterion {
		//По группе
		case "group":

			// ИЗМЕНЕНО: намного быстрее и проще оказалось получать пары по имени,
			// поэтому теперь мы будем делать только так, функции sg.GetIdByName, sg.GetClassesById будут в скором времени удалены,
			// внесите изменения в код там, где они используются

			newgroup := database.StudentGroup{Name: value}
			filteredLessons, err = database.Database.StudentGroup.GetClassesByName(&newgroup)
			if err != nil {
				c.String(http.StatusBadRequest, err.Error())
				return
			}

			//}
			//По преподавателю
		case "tutor":
			tempclass := &database.Class{TeacherName: value}
			//Получаем список пар по преподу
			filteredLessons, err = database.Database.Class.GetForTeacher(tempclass)
			if err != nil {
				c.String(http.StatusBadRequest, err.Error())
				return
			}

			//По аудитории
		case "classroom":
			//Заданное value присваивается полю вудитории пары
			lesson.Location = value
			//Получаем список пар по аудитории
			filteredLessons, err = database.Database.Class.GetByLocation(lesson)
			if err != nil {
				c.String(http.StatusBadRequest, err.Error())
				return
			}
			//При неверном критерии вернет BadRequest
		default:
			c.String(http.StatusBadRequest, "There is no such criterion")
			return
		}

		if len(*filteredLessons) != 0 {
			//Добавляем в кэш значение
			cache.Set(value, filteredLessons)
			//Возвращаем StatusOK и пары по заданным значениям
			c.JSON(http.StatusOK, filteredLessons)
		} else {
			switch criterion {
			case "group":
				c.JSON(http.StatusBadRequest, "There is no such group")
			case "tutor":
				c.JSON(http.StatusBadRequest, "There is no such tutor")
			case "classroom":
				c.JSON(http.StatusBadRequest, "There is no such classroom")
			}
		}
	}
}
