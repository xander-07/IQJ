package handler

import (
	"iqj/database"
	cache2 "iqj/pkg/cache"
	"iqj/pkg/excel_parser"
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

//Использование кэша
var cache = cache2.NewLFUCache(100)

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
	} else { //Если нет, запускаем парсер //TODO: Сделать запуск парсера одноразовым, а не при каждом запросе
		err := excel_parser.Parse()
		//Обработка ошибок при парсинге
		if err != nil {
			c.String(http.StatusBadRequest, err.Error())
			return
		}
		//Switch по заданному критерию
		switch criterion {
		//По группе
		//Может не работать из-за того, что в базу не добавляются группы, следовательно ID неоткуда брать
		case "group":
			//Создание группы
			group := &database.StudentGroup{}
			//Заданное value присваивается полю имени группы
			group.Name = value
			//Поиск ID группы по имени
			group, err := database.Database.StudentGroup.GetIdByName(group)
			if err != nil {
				c.String(http.StatusBadRequest, err.Error())
			}
			//Получаем список пар по группе из БД
			filteredLessons1, err := database.Database.StudentGroup.GetClasses(group)
			if err != nil {
				c.String(http.StatusBadRequest, err.Error())
			}
			filteredLessons = &filteredLessons1

		//По преподавателю
		case "tutor":
			//Заданное value присваивается полю ФИО препода пары
			lesson.TeacherName = value
			//Получаем список пар по преподу
			filteredLessons, err = database.Database.Class.GetForWeekByTeacher(lesson)
			if err != nil {
				c.String(http.StatusBadRequest, err.Error())
			}
			
		//По аудитории
		case "classroom":
			//Заданное value присваивается полю вудитории пары
			lesson.Location = value
			//Получаем список пар по аудитории
			filteredLessons, err = database.Database.Class.GetByLocation(lesson)
			if err != nil {
				c.String(http.StatusBadRequest, err.Error())
			}
		//При неверном критерии вернет BadRequest
		default:
			c.String(http.StatusBadRequest, err.Error())
			return
		}
	}
	//Добавляем в кэш значение
	cache.Set(value, filteredLessons)

	//Возвращаем StatusOK и пары по заданным значениям
	c.JSON(http.StatusOK, filteredLessons)
}
