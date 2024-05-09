package handler

import (
	"fmt"
	"iqj/database"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Структура получаемого из тела запроса JSON
type UpdateUser struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	Role     string `json:"role"`
}

// Для пользователей с ролью moderator
// получает JSON в теле запроса вида:
//
//	{
//		"email": " ",
//		"password": " ",
//		"role": " "
//		}
//
// меняет роль пользователя в бд на переданную в теле запроса.
// PUT /api/update_role
func (h *Handler) HandleUpdateUserRole(c *gin.Context) {
	userIdToConv, ok := c.Get("userId")
	if !ok {
		c.String(http.StatusUnauthorized, "User ID not found")
		fmt.Println("HandleUpdateUserRole:", ok)
		return
	}
	userId := userIdToConv.(int)

	user, err := database.Database.UserData.GetRoleById( // у этого юзера будет роль, все хорошо -> user.Role
		&database.UserData{
			Id: int64(userId),
		})
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleUpdateUserRole:", err)
		return
	}

	if user.Role == "moderator" {
		var updateUser UpdateUser
		if err = c.BindJSON(&updateUser); err != nil {
			c.String(http.StatusBadRequest, err.Error())
			fmt.Println("HandleUpdateUserRole:", err)
			return
		}

		var userDB database.User
		userDB.Email = updateUser.Email
		userDB.Password = updateUser.Password
		var user2 *database.User
		if user2, err = database.Database.User.Check(&userDB); err != nil {
			c.String(http.StatusUnauthorized, "") // Если пользователя нет или пароль неверный вернем пустую строку и ошибку
			fmt.Println("HandleUpdateUserRole:", err)
			return
		}

		var userData database.UserData
		userData.Id = user2.Id
		userData.Role = updateUser.Role

		if err = database.Database.UserData.UpdateRole(&userData); err != nil {
			c.JSON(http.StatusInternalServerError, err.Error())
			fmt.Println("HandleUpdateUserRole:", err)
			return
		}
		c.JSON(http.StatusOK, userData)
	} else {
		c.JSON(http.StatusForbidden, "There are not enough rights for this action")
	}
}
