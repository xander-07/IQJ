package handler

import (
	"fmt"
	"iqj/database"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// Получает offset и count из запроса, вызывает функцию GetLatestNewsBlocks,
// которая вернет массив с последними новостями.
// Выдает новости пользователю в формате JSON.
// Например при GET /news?offset=1&count=5 вернет новости с первой по шестую.
func (h *Handler) HandleGetNews(c *gin.Context) {
	// Получаем промежуток пропуска и количество блоков новостей
	offsetStr := c.Query("offset")
	countStr := c.Query("count")

	offset, err := strconv.Atoi(offsetStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleGetNews:", err)
		return
	}
	switch {
	case offset < 0:
		c.JSON(http.StatusBadRequest, "Offset < 0")
		fmt.Println("HandleGetNews: offset < 0")
		return
	case offset > 999999:
		c.JSON(http.StatusBadRequest, "Offset > 999999")
		fmt.Println("HandleGetNews: offset > 999999")
		return
	}

	count, err := strconv.Atoi(countStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleGetNews:", err)
		return
	}
	switch {
	case count < 1:
		c.JSON(http.StatusBadRequest, "Count < 1")
		fmt.Println("HandleGetNews: count < 1")
		return
	case count > 999999:
		c.JSON(http.StatusBadRequest, "Count > 999999")
		fmt.Println("HandleGetNews: count > 999999")
		return
	}

	latestnews, err := database.Database.News.GetLatestBlocks(count, offset)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleGetNews:", err)
		return
	}
	c.JSON(http.StatusOK, latestnews)
}

// Извлекает id из параметров запроса,
// вызывает функцию GetNewsByID, которая получает полную новость из бд.
// Выдает полную новость пользователю в формате JSON.
// Например при GET /newsid?id=13 вернет новость с id = 13.
func (h *Handler) HandleGetNewsById(c *gin.Context) {
	idStr := c.Query("id")

	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		fmt.Println("HandleGetNewsById:", err)
		return
	}
	switch {
	case id < 0:
		c.JSON(http.StatusBadRequest, "Id < 0")
		fmt.Println("HandleGetNewsById: id < 0")
		return
	case id > 999999:
		c.JSON(http.StatusBadRequest, "Id > 999999")
		fmt.Println("HandleGetNewsById: id > 999999")
		return
	}

	var newsDB database.News
	newsDB.Id = id

	news, err := database.Database.News.GetById(&newsDB)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleGetNewsById:", err)
		return
	}
	c.JSON(http.StatusOK, news)
}

// Для пользователей с ролью moderator
// получает JSON в теле запроса вида:
//
//	{
//		"header": " ",
//		"link": " ",
//		"image_link": [
//			" "
//		],
//		"tags": [
//			" "
//		],
//		"publication_time": " ",
//		"text": " "
//	}
//
// создает в бд переданную новость.
// POST /api/news
func (h *Handler) HandleAddNews(c *gin.Context) {
	userIdToConv, exists := c.Get("userId")
	if !exists {
		c.JSON(http.StatusUnauthorized, "User ID not found")
		fmt.Println("HandleAddNews:", exists)
		return
	}
	userId := userIdToConv.(int)
	var userDB database.UserData
	userDB.Id = userId
	user, err := database.Database.UserData.GetRoleById(&userDB)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleAddNews:", err)
		return
	}
	if user.Role == "moderator" {
		var news database.News
		err := c.BindJSON(&news)
		if err != nil {
			c.JSON(http.StatusBadRequest, err.Error())
			fmt.Println("HandleAddNews:", err)
			return
		}
		ok := database.Database.News.Add(&news)
		if ok != nil {
			c.JSON(http.StatusInternalServerError, ok.Error())
			fmt.Println("HandleAddNews:", ok)
			return
		}
		c.JSON(http.StatusOK, news)
	} else {
		c.JSON(http.StatusForbidden, "There are not enough rights for this action")
	}
}

// Функция для получения всех полных новостей, имеющихся в бд на данный момент.
// Извлекает из запроса параметр all, который должен быть равен 1 для корректной работы
// Используется функция GetAllNews, которая получает срез всех новостей в бд
// Использование с GET: /news?all=1
func (h *Handler) HandleGetAllNews(c *gin.Context) {
	allStr := c.Query("all")

	all, err := strconv.Atoi(allStr)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		fmt.Println("HandleGetAllNews:", err)
		return
	}

	if all != 1 {
		c.JSON(http.StatusBadRequest, "All != 1")
		fmt.Println("HandleGetAllNews: all != 1")
		return
	}

	allnews, err := database.Database.News.GetAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleGetAllNews:", err)
		return
	}
	c.JSON(http.StatusOK, allnews)
}

// Функция для обновления новости по её id.
// Использование с PUT: /api/news
func (h *Handler) HandleUpdateNews(c *gin.Context) {
	userIdToConv, ok := c.Get("userId")
	if !ok {
		c.String(http.StatusUnauthorized, "User ID not found")
		fmt.Println("HandleUpdateNews:", ok)
		return
	}
	userId := userIdToConv.(int)

	user, err := database.Database.UserData.GetRoleById(
		&database.UserData{
			Id: userId,
		})
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleUpdateNews:", err)
		return
	}

	if user.Role == "moderator" {
		var news database.News

		err := c.BindJSON(&news)
		if err != nil {
			c.String(http.StatusBadRequest, err.Error())
			fmt.Println("HandleUpdateNews:", err)
			return
		}

		ok := database.Database.News.Update(&news)
		if ok != nil {
			c.JSON(http.StatusInternalServerError, ok.Error())
			fmt.Println("HandleUpdateNews:", ok)
			return
		}

		c.JSON(http.StatusOK, news)
	} else {
		c.JSON(http.StatusForbidden, "There are not enough rights for this action")
	}
}
