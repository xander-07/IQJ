package handler

import (
	"context"
	"fmt"
	"iqj/api/firebase"
	"net/http"
	"time"

	"firebase.google.com/go/v4/auth"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/iterator"
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
	Faculty        string `json:"faculty"`
	DateOfBirth    string `json:"date_of_birth"`
}

// Вывод всех пользователей из firebase
func (h *Handler) HandleListUsers(c *gin.Context) {
	client, err := firebase.InitFirebase()
	if err != nil {
		c.JSON(http.StatusInternalServerError, err)
		fmt.Println("HandleListUsers: Firebase initialization error: %s\n", err)
		return
	}
	iter := client.Users(context.Background(), "")

	var userList []UserInfo
	var userInfo UserInfo
	for {
		user, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			fmt.Println("HandleListUsers: error listing users: %s\n", err)
		}
		userInfo.UID = user.UID
		userInfo.Email = user.Email
		userInfo.PasswordHash = user.PasswordHash
		userInfo.PasswordSalt = user.PasswordSalt
		userInfo.DisplayName = user.DisplayName
		userInfo.PhoneNumber = user.PhoneNumber
		userInfo.LastSignInTime = time.Unix(user.UserMetadata.LastLogInTimestamp/1000, 0).Format("2006-01-02 15:04:05")
		userInfo.CreationTime = time.Unix(user.UserMetadata.CreationTimestamp/1000, 0).Format("2006-01-02 15:04:05")

		// Получаем пользовательские поля
		customClaims := user.CustomClaims
		if customClaims != nil {
			if position, ok := customClaims["position"].(string); ok {
				userInfo.Position = position
			}
			if faculty, ok := customClaims["faculty"].(string); ok {
				userInfo.Faculty = faculty
			}
			if dateOfBirth, ok := customClaims["date_of_birth"].(string); ok {
				userInfo.DateOfBirth = dateOfBirth
			}
		}

		userList = append(userList, userInfo)
	}

	c.JSON(http.StatusOK, userList)
}

func (h *Handler) HandleUpdateFirebaseUser(c *gin.Context) {
	uid := c.Query("uid")

	client, err := firebase.InitFirebase()
	if err != nil {
		c.JSON(http.StatusInternalServerError, err)
		fmt.Println("HandleUpdateFirebaseUser: Firebase initialization error: %s\n", err)
		return
	}
	var userUpdate UserInfo
	err = c.BindJSON(&userUpdate)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleUpdateFirebaseUser:", err)
		return
	}
	params := (&auth.UserToUpdate{}).
		Email(userUpdate.Email).
		PhoneNumber(userUpdate.PhoneNumber).
		Password("newPassword"). //TODO: придумать что-то с паролем
		DisplayName(userUpdate.DisplayName).
		CustomClaims(map[string]interface{}{"position": userUpdate.Position}).
		CustomClaims(map[string]interface{}{"Faculty": userUpdate.Faculty}).
		CustomClaims(map[string]interface{}{"date_of_birth": userUpdate.DateOfBirth})

	u, err := client.UpdateUser(context.Background(), uid, params)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err)
		fmt.Println("HandleUpdateFirebaseUser: Firebase initialization error: %s\n", err)
	}
	fmt.Println(u)
}
