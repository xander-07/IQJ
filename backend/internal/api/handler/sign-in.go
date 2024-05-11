package handler

import (
	"fmt"
	"iqj/internal/database"
	"iqj/pkg/middleware"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Вход в систему
// получает JSON в теле запроса вида:
//
//	{
//		"email": "ivanovivan@yandex.ru",
//		"password": "qwerty1234"
//	}
//
// и проверяет их.
// Возвращаем JWT.
// POST /sign-in
func (h *Handler) HandleSignIn(c *gin.Context) {

	// Получаем данные, введенные пользователем из тела запроса и записываем их в signingUser
	var signingUser database.User
	err := c.BindJSON(&signingUser)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleSignIn:", err)
		return
	}

	if signingUser.Email == "" {
		c.JSON(http.StatusBadRequest, "There is no email")
		fmt.Println("HandleSignIn: There is no email")
		return
	}

	if signingUser.Password == "" {
		c.JSON(http.StatusBadRequest, "There is no password")
		fmt.Println("HandleSignIn: There is no password")
		return
	}

	// Проверяем существует ли такой пользователь и проверяем верный ли пароль
	user, err := database.Database.User.Check(&signingUser)
	if err != nil {
		c.String(http.StatusUnauthorized, "") // Если пользователя нет или пароль неверный вернем пустую строку и ошибку
		fmt.Println("HandleSignIn:", err)
		return
	}
	// Если все хорошо сделаем JWT токен

	// Получаем токен для пользователя
	token, err := middleware.GenerateJWT(int(user.Id))
	if err != nil {
		c.String(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleSignIn:", err)
		return
	}

	//Выводим токен в формате JSON
	c.JSON(http.StatusOK, token)
}

// Вход в систему для панели админа
// получает JSON в теле запроса вида:
//
//	{
//		"email": "ivanovivan@yandex.ru",
//		"password": "qwerty1234"
//	}
//
// и проверяет их.
// Возвращаем JWT, если у пользователя роль moderator.
// POST /web_sign-in
func (h *Handler) HandleWebSignIn(c *gin.Context) {
	// Получаем данные, введенные пользователем из тела запроса и записываем их в signingUser
	var signingUser database.User
	err := c.BindJSON(&signingUser)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleWebSignIn:", err)
		return
	}

	if signingUser.Email == "" {
		c.JSON(http.StatusBadRequest, "There is no email")
		fmt.Println("HandleWebSignIn: There is no email")
		return
	}

	if signingUser.Password == "" {
		c.JSON(http.StatusBadRequest, "There is no password")
		fmt.Println("HandleWebSignIn: There is no password")
		return
	}

	// Проверяем существует ли такой пользователь и проверяем верный ли пароль
	user, err := database.Database.User.Check(&signingUser)
	if err != nil {
		c.String(http.StatusUnauthorized, "") // Если пользователя нет или пароль неверный вернем пустую строку и ошибку
		fmt.Println("HandleWebSignIn:", err)
		return
	}
	// Если все хорошо сделаем JWT токен

	// Получаем токен для пользователя
	token, err := middleware.GenerateJWT(int(user.Id))
	if err != nil {
		c.String(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleWebSignIn:", err)
		return
	}

	userData, err := database.Database.UserData.GetRoleById(
		&database.UserData{
			Id: user.Id,
		})
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleWebSignIn:", err)
		return
	}

	if userData.Role == "moderator" {
		//Выводим токен в формате JSON
		c.JSON(http.StatusOK, token)
	} else {
		c.JSON(http.StatusForbidden, "There are not enough rights for this action")
	}
}
