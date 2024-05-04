package handler

import (
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	"google.golang.org/api/iterator"
	"iqj/api/firebase"
	"net/http"
	"time"
)

type UserInfo struct {
	UID            string `json:"uid"`
	Email          string `json:"email"`
	PasswordHash   string `json:"password_hash"`
	PasswordSalt   string `json:"password_salt"`
	DisplayName    string `json:"display_name"`
	PhoneNumber    string `json:"phone_number"`
	LastSignInTime string `json:"last_sign_in_time"`
	CreationTime   string `json:"creation_time"`
}

// Вывод всех пользователей из firebase
func (h *Handler) HandleListUsers(c *gin.Context) {
	client, err := firebase.InitFirebase()
	if err != nil {
		fmt.Println("ListUsers: Firebase initialization error: %s\n", err)
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
			fmt.Println("ListUsers: error listing users: %s\n", err)
		}
		userInfo.UID = user.UID
		userInfo.Email = user.Email
		userInfo.PasswordHash = user.PasswordHash
		userInfo.PasswordSalt = user.PasswordSalt
		userInfo.DisplayName = user.DisplayName
		userInfo.PhoneNumber = user.PhoneNumber
		userInfo.LastSignInTime = time.Unix(user.UserMetadata.LastLogInTimestamp/1000, 0).Format("2006-01-02 15:04:05")
		userInfo.CreationTime = time.Unix(user.UserMetadata.CreationTimestamp/1000, 0).Format("2006-01-02 15:04:05")

		userList = append(userList, userInfo)
	}

	c.JSON(http.StatusOK, userList)
}
