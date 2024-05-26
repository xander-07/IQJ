package handler

import (
	"fmt"
	"iqj/pkg/middleware"
	"net/http"

	"github.com/gin-gonic/gin"
)

type SignIn struct {
	Uid string `json:"uid"`
}

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
	var signIn SignIn
	err := c.BindJSON(&signIn)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleSignIn:", err)
		return
	}

	if signIn.Uid == "" {
		c.JSON(http.StatusBadRequest, "There is no signIn")
		fmt.Println("HandleSignIn: There is no signIn")
		return
	}
	// Если все хорошо сделаем JWT токен

	// Получаем токен для пользователя
	token, err := middleware.GenerateJWT(signIn.Uid)
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
	var signIn SignIn
	err := c.BindJSON(&signIn)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleSignIn:", err)
		return
	}

	if signIn.Uid == "" {
		c.JSON(http.StatusBadRequest, "There is no signIn")
		fmt.Println("HandleSignIn: There is no signIn")
		return
	}
	// Если все хорошо сделаем JWT токен

	// 	TODO: Добавить проверку роли пользователя на администратора

	// Получаем токен для пользователя
	token, err := middleware.GenerateJWT(signIn.Uid)
	if err != nil {
		c.String(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleSignIn:", err)
		return
	}

	//Выводим токен в формате JSON
	c.JSON(http.StatusOK, token)

}
