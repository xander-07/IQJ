package handler

import (
	"firebase.google.com/go/v4/auth"
	"fmt"
	"github.com/gin-gonic/gin"
	"golang.org/x/net/context"
	"google.golang.org/api/iterator"
	"iqj/internal/api/firebase"
	"iqj/internal/database"
	"net/http"
	"strings"
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
	Picture        string `json:"picture"`
}

type User struct {
	UID         string `json:"uid"`
	Email       string `json:"email"`
	Password    string `json:"password"`
	DisplayName string `json:"display_name"`
	PhoneNumber string `json:"phone_number"`
	Position    string `json:"position"`
	Institute   string `json:"institute"`
	Role        string `json:"role"`
	Picture     string `json:"picture"`
}

// Вывод всех пользователей из firebase
func (h *Handler) HandleListUsers(c *gin.Context) {
	userIdToConv, ok := c.Get("userId")
	if !ok {
		c.String(http.StatusUnauthorized, "User ID not found")
		fmt.Println("HandleUpdateNews:", ok)
		return
	}
	userId := userIdToConv.(int)

	user, err := database.Database.UserData.GetRoleById(
		database.UserData{
			Id: int64(userId),
		})
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleUpdateNews:", err)
		return
	}

	if user.Role == "moderator" {
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
			userInfo.UID = getStringFromData(userFirestore.Data(), "uid")
			userInfo.DisplayName = buildFullName(userFirestore.Data())
			userInfo.Position = getStringFromData(userFirestore.Data(), "position")
			userInfo.Email = getStringFromData(userFirestore.Data(), "email")
			userInfo.Institute = getStringFromData(userFirestore.Data(), "institute")
			userInfo.PhoneNumber = getStringFromData(userFirestore.Data(), "phone")
			userInfo.Role = getStringFromData(userFirestore.Data(), "role")
			userInfo.Picture = getStringFromData(userFirestore.Data(), "picture")

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
			if i == len(userList) {
				break
			}

			// Добавление информации о пользовательской аутентификации к данным пользователя
			userList[i].PasswordHash = userAuth.PasswordHash
			userList[i].PasswordSalt = userAuth.PasswordSalt
			userList[i].LastSignInTime = time.Unix(userAuth.UserMetadata.LastLogInTimestamp/1000, 0).Format("2006-01-02 15:04:05")
			userList[i].CreationTime = time.Unix(userAuth.UserMetadata.CreationTimestamp/1000, 0).Format("2006-01-02 15:04:05")

			i++
		}
		c.JSON(http.StatusOK, userList)
	} else {
		c.JSON(http.StatusForbidden, "There are not enough rights for this action")
	}
}

func getStringFromData(data map[string]interface{}, key string) string {
	value, ok := data[key].(string)
	if !ok {
		return "" // Возвращаем пустую строку, если ключ отсутствует или значение не является строкой
	}
	return value
}

func buildFullName(data map[string]interface{}) string {
	var fullName string
	surname := getStringFromData(data, "surname")
	name := getStringFromData(data, "name")
	patronymic := getStringFromData(data, "patronymic")

	if surname != "" {
		fullName += surname + " "
	}
	if name != "" {
		fullName += name + " "
	}
	if patronymic != "" {
		fullName += patronymic
	}

	return fullName
}

func (h *Handler) HandleCreateFirebaseUser(c *gin.Context) {
	userIdToConv, ok := c.Get("userId")
	if !ok {
		c.String(http.StatusUnauthorized, "User ID not found")
		fmt.Println("HandleCreateFirebaseUser:", ok)
		return
	}
	userId := userIdToConv.(int)

	user, err := database.Database.UserData.GetRoleById(
		database.UserData{
			Id: int64(userId),
		})
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleCreateFirebaseUser:", err)
		return
	}

	if user.Role == "moderator" {
		var userFirebase User

		err := c.BindJSON(&userFirebase)
		if err != nil {
			c.String(http.StatusBadRequest, err.Error())
			fmt.Println("HandleCreateFirebaseUser:", err)
			return
		}

		clientAuth, err := firebase.InitFirebase().Auth(context.Background())
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Printf("HandleListUsers: Firebase initialization error: %s\n", err)
			return
		}

		params := (&auth.UserToCreate{}).
			Email(userFirebase.Email).
			EmailVerified(false).
			Password(userFirebase.Password).
			PhoneNumber(userFirebase.PhoneNumber).
			DisplayName(userFirebase.DisplayName)

		u, err := clientAuth.CreateUser(context.Background(), params)
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Println("HandleCreateFirebaseUser:", err)
			return
		}

		clientFirestore, err := firebase.InitFirebase().Firestore(context.Background())
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Println("HandleCreateFirebaseUser: Firebase initialization error: %s\n", err)
			return
		}

		defer clientFirestore.Close()

		fullName := strings.Fields(userFirebase.DisplayName)

		_, err = clientFirestore.Collection("users").Doc(u.UID).Set(context.Background(), map[string]interface{}{
			"email":      userFirebase.Email,
			"institute":  userFirebase.Institute,
			"name":       fullName[1],
			"patronymic": fullName[2],
			"phone":      userFirebase.PhoneNumber,
			"position":   userFirebase.Position,
			"role":       userFirebase.Role,
			"surname":    fullName[0],
			"uid":        u.UID,
			"picture":    userFirebase.Picture,
		})
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			return
		}

		c.JSON(http.StatusCreated, userFirebase)
	} else {
		c.JSON(http.StatusForbidden, "There are not enough rights for this action")
	}
}

func (h *Handler) HandleUpdateFirebaseUser(c *gin.Context) {
	userIdToConv, ok := c.Get("userId")
	if !ok {
		c.String(http.StatusUnauthorized, "User ID not found")
		fmt.Println("HandleUpdateFirebaseUser:", ok)
		return
	}
	userId := userIdToConv.(int)

	user, err := database.Database.UserData.GetRoleById(
		database.UserData{
			Id: int64(userId),
		})
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleUpdateFirebaseUser:", err)
		return
	}

	if user.Role == "moderator" {
		var userFirebase User

		err := c.BindJSON(&userFirebase)
		if err != nil {
			c.String(http.StatusBadRequest, err.Error())
			fmt.Println("HandleUpdateFirebaseUser:", err)
			return
		}

		clientAuth, err := firebase.InitFirebase().Auth(context.Background())
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Printf("HandleUpdateFirebaseUser: Firebase initialization error: %s\n", err)
			return
		}

		params := (&auth.UserToUpdate{}).
			Email(userFirebase.Email).
			Password(userFirebase.Password).
			PhoneNumber(userFirebase.PhoneNumber).
			DisplayName(userFirebase.DisplayName)

		u, err := clientAuth.UpdateUser(context.Background(), userFirebase.UID, params)
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Println("HandleUpdateFirebaseUser:", err)
			return
		}

		clientFirestore, err := firebase.InitFirebase().Firestore(context.Background())
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Println("HandleUpdateFirebaseUser: Firebase initialization error: %s\n", err)
			return
		}

		defer clientFirestore.Close()

		fullName := strings.Fields(userFirebase.DisplayName)

		_, err = clientFirestore.Collection("users").Doc(u.UID).Set(context.Background(), map[string]interface{}{
			"email":      userFirebase.Email,
			"institute":  userFirebase.Institute,
			"name":       fullName[1],
			"patronymic": fullName[2],
			"phone":      userFirebase.PhoneNumber,
			"position":   userFirebase.Position,
			"role":       userFirebase.Role,
			"surname":    fullName[0],
			"uid":        u.UID,
			"picture":    userFirebase.Picture,
		})
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			return
		}

		c.JSON(http.StatusCreated, userFirebase)
	} else {
		c.JSON(http.StatusForbidden, "There are not enough rights for this action")
	}
}

func (h *Handler) HandleDeleteFirebaseUser(c *gin.Context) {
	userIdToConv, ok := c.Get("userId")
	if !ok {
		c.String(http.StatusUnauthorized, "User ID not found")
		fmt.Println("HandleUpdateNews:", ok)
		return
	}
	userId := userIdToConv.(int)

	user, err := database.Database.UserData.GetRoleById(
		database.UserData{
			Id: int64(userId),
		})
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		fmt.Println("HandleUpdateNews:", err)
		return
	}

	if user.Role == "moderator" {
		uidStr := c.Query("uid")

		clientAuth, err := firebase.InitFirebase().Auth(context.Background())
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Printf("HandleDeleteFirebaseUser: Firebase initialization error: %s\n", err)
			return
		}

		if err := clientAuth.DeleteUser(context.Background(), uidStr); err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Printf("HandleDeleteFirebaseUser: Firebase initialization error: %s\n", err)
			return
		}

		clientFirestore, err := firebase.InitFirebase().Firestore(context.Background())
		if err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Println("HandleDeleteFirebaseUser: Firebase initialization error: %s\n", err)
			return
		}

		defer clientFirestore.Close()

		// Удаление данных пользователя из Firestore
		if _, err := clientFirestore.Collection("users").Doc(uidStr).Delete(context.Background()); err != nil {
			c.JSON(http.StatusInternalServerError, err)
			fmt.Println("HandleDeleteFirebaseUser: Firebase initialization error: %s\n", err)
			return
		}

		c.JSON(http.StatusNoContent, fmt.Sprintf("The user with the uid=%v was successfully deleted", uidStr))
	} else {
		c.JSON(http.StatusForbidden, "There are not enough rights for this action")
	}
}
