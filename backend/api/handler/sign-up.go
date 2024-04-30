package handler

import (
	"fmt"
	"iqj/database"
	"net/http"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

// Регистрация
// получает JSON в теле запроса вида:
//
//	{
//		"email": "ivanovivan@yandex.ru",
//		"password": "qwerty1234"
//	}
//
// создает в бд пользователя с переданными данными.
// POST /sign-up
func (h *Handler) HandleSignUp(c *gin.Context) {
	var user database.User

	ok := c.BindJSON(&user)
	if ok != nil {
		c.JSON(http.StatusBadRequest, ok.Error())
		fmt.Println("HandleSignUp:", ok)
		return
	}

	if user.Email == "" {
		c.JSON(http.StatusBadRequest, "There is no email")
		fmt.Println("HandleSignUp: There is no email")
		return
	}

	if user.Password == "" {
		c.JSON(http.StatusBadRequest, "There is no password")
		fmt.Println("HandleSignUp: There is no password")
		return
	}

	password := user.Password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleSignUp:", err)
		return
	}

	user.Password = string(hashedPassword)
	if err = database.Database.User.Add(&user); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleSignUp:", err)
		return
	}

	c.JSON(http.StatusOK, user)
}
