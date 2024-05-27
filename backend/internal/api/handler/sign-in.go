package handler

import (
	"fmt"
	"golang.org/x/net/context"
	"iqj/internal/api/firebase"
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

type WebTokens struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
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
		fmt.Println("HandleWebSignIn:", err)
		return
	}

	if signIn.Uid == "" {
		c.JSON(http.StatusBadRequest, "There is no signIn")
		fmt.Println("HandleWebSignIn: There is no signIn")
		return
	}

	clientFirestore, err := firebase.InitFirebase().Firestore(context.Background())
	if err != nil {
		c.JSON(http.StatusInternalServerError, err)
		fmt.Printf("HandleWebSignIn: Firebase initialization error: %s\n", err)
		return
	}

	defer clientFirestore.Close()

	docRef := clientFirestore.Collection("users").Doc(signIn.Uid)

	doc, err := docRef.Get(context.Background())
	if err != nil {
		c.JSON(http.StatusInternalServerError, err)
		fmt.Println("HandleWebSignIn:", err)
		return
	}

	data := doc.Data()
	role, ok := data["role"].(string)
	if !ok {
		c.JSON(http.StatusInternalServerError, err)
		fmt.Println("HandleWebSignIn:", err)
		return
	}

	if role == "administrator" {
		var tokens WebTokens

		// Если все хорошо сделаем JWT токен

		// Получаем токен для пользователя
		tokens.AccessToken, err = middleware.GenerateAccessToken(signIn.Uid)
		if err != nil {
			c.String(http.StatusInternalServerError, err.Error())
			fmt.Println("HandleWebSignIn:", err)
			return
		}

		tokens.RefreshToken, err = middleware.GenerateRefreshToken(signIn.Uid)
		if err != nil {
			c.String(http.StatusInternalServerError, err.Error())
			fmt.Println("HandleWebSignIn:", err)
			return
		}

		//Выводим токен в формате JSON
		c.JSON(http.StatusOK, tokens)
	} else {
		c.JSON(http.StatusForbidden, "There are not enough rights for this action")
	}

}
