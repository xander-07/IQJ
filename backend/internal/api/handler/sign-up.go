package handler

import (
	"fmt"
	"iqj/internal/database"
	"net/http"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

// Структура получаемого из тела запроса JSON
type FullUser struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	Name     string `json:"name"`
}

// Регистрация
// получает JSON в теле запроса вида:
//
//	{
//		"email": " ",
//		"password": " ",
//		"name": " "
//	}
//
// создает в бд пользователя с переданными данными.
// POST /sign-up
func (h *Handler) HandleSignUp(c *gin.Context) {
	var fullUser FullUser

	ok := c.BindJSON(&fullUser)
	if ok != nil {
		c.JSON(http.StatusBadRequest, ok.Error())
		fmt.Println("HandleSignUp:", ok)
		return
	}

	if fullUser.Email == "" {
		c.JSON(http.StatusBadRequest, "There is no email")
		fmt.Println("HandleSignUp: There is no email")
		return
	}

	if fullUser.Password == "" {
		c.JSON(http.StatusBadRequest, "There is no password")
		fmt.Println("HandleSignUp: There is no password")
		return
	}
	var user database.User
	user.Email = fullUser.Email
	password := fullUser.Password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleSignUp:", err)
		return
	}

	user.Password = string(hashedPassword)
	var userDb *database.User
	if userDb, err = database.Database.User.AddNew(user); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleSignUp:", err)
		return
	}

	var userData database.UserData
	userData.Id = userDb.Id
	userData.Name = fullUser.Name
	userData.Role = "student"
	if err = database.Database.UserData.Add(userData); err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleSignUp:", err)
		return
	}
	c.JSON(http.StatusOK, user.Id)
}
