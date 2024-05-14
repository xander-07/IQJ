package handler

import (
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/iterator"
	"iqj/internal/api/firebase"
	"net/http"
	"time"
)

// Структура для вывода всей информации о пользователе
type UserInfo struct {
	UID            string `json:"uid"`
	Email          string `json:"email"`
	PasswordHash   string `json:"password_hash"`
	PasswordSalt   string `json:"password_salt"`
	DisplayName    string `json:"display_name"`
	PhoneNumber    string `json:"phone_number"`
	LastSignInTime string `json:"last_sign_in_time"`
	CreationTime   string `json:"creation_time"`
	Position       string `json:"position"`
	Institute      string `json:"institute"`
	Role           string `json:"role"`
}

// Вывод всех пользователей из firebase
func (h *Handler) HandleListUsers(c *gin.Context) {
	// Инициализация клиента для вывода uid, ФИО, должности, почты, института и номера телефона
	clientFirestore, err := firebase.InitFirebase().Firestore(context.Background())
	if err != nil {
		c.JSON(http.StatusInternalServerError, err)
		fmt.Printf("HandleListUsers: Firebase initialization error: %s\n", err)
		return
	}

	defer clientFirestore.Close()

	iterFirestore := clientFirestore.Collection("users").Documents(context.Background())
	var userList []UserInfo
	for {
		userFirestore, err := iterFirestore.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			c.JSON(http.StatusInternalServerError, err.Error())
			fmt.Println("HandleListUsers:", err)
			return
		}

		var userInfo UserInfo

		// Получение данных пользователя из Firestore
		userInfo.UID = userFirestore.Data()["uid"].(string)
		userInfo.DisplayName = userFirestore.Data()["surname"].(string) + " " + userFirestore.Data()["name"].(string) + " " + userFirestore.Data()["patronymic"].(string)
		userInfo.Position = userFirestore.Data()["position"].(string)
		userInfo.Email = userFirestore.Data()["email"].(string)
		userInfo.Institute = userFirestore.Data()["institute"].(string)
		userInfo.PhoneNumber = userFirestore.Data()["phone"].(string)
		userInfo.Role = userFirestore.Data()["role"].(string)

		userList = append(userList, userInfo)
	}

	// Инициализация клиента для вывода информации захэшированного пароля,
	// "соли" пароля, даты регистрации пользователя и даты последнего входа
	clientAuth, err := firebase.InitFirebase().Auth(context.Background())
	if err != nil {
		c.JSON(http.StatusInternalServerError, err)
		fmt.Printf("HandleListUsers: Firebase initialization error: %s\n", err)
		return
	}

	defer clientFirestore.Close()

	// Получение информации о пользовательской аутентификации
	iterAuth := clientAuth.Users(context.Background(), "")
	i := 0
	for {
		userAuth, err := iterAuth.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			fmt.Printf("HandleListUsers: error listing users: %s\n", err)
		}

		// Добавление информации о пользовательской аутентификации к данным пользователя
		userList[i].PasswordHash = userAuth.PasswordHash
		userList[i].PasswordSalt = userAuth.PasswordSalt
		userList[i].LastSignInTime = time.Unix(userAuth.UserMetadata.LastLogInTimestamp/1000, 0).Format("2006-01-02 15:04:05")
		userList[i].CreationTime = time.Unix(userAuth.UserMetadata.CreationTimestamp/1000, 0).Format("2006-01-02 15:04:05")

		i++
	}
	c.JSON(http.StatusOK, userList)
}

func (h *Handler) HandleUpdateFirebaseUser(c *gin.Context) {
	//uid := c.Query("uid")
	//
	//client, err := firebase.InitFirebase().Auth(context.Background())
	//if err != nil {
	//	c.JSON(http.StatusInternalServerError, err)
	//	fmt.Printf("HandleUpdateFirebaseUser: Firebase initialization error: %s\n", err)
	//	return
	//}
	//
	//var userUpdate UserInfo
	//err = c.BindJSON(&userUpdate)
	//if err != nil {
	//	c.JSON(http.StatusBadRequest, err.Error())
	//	fmt.Println("HandleUpdateFirebaseUser:", err)
	//	return
	//}
	//params := (&auth.UserToUpdate{}).
	//	Email(userUpdate.Email).
	//	PhoneNumber(userUpdate.PhoneNumber).
	//	Password("newPassword"). //TODO: придумать что-то с паролем
	//	DisplayName(userUpdate.DisplayName).
	//	CustomClaims(map[string]interface{}{"position": userUpdate.Position}).
	//	CustomClaims(map[string]interface{}{"Faculty": userUpdate.Faculty}).
	//	CustomClaims(map[string]interface{}{"date_of_birth": userUpdate.DateOfBirth})
	//
	//u, err := client.UpdateUser(context.Background(), uid, params)
	//if err != nil {
	//	c.JSON(http.StatusInternalServerError, err)
	//	fmt.Printf("HandleUpdateFirebaseUser: Firebase initialization error: %s\n", err)
	//}
	//fmt.Println(u)
}
