package middleware

import (
	"errors"
	"fmt"
	"iqj/config"
	"net/http"
	"strings"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

// Структура для параметров JWT
type tokenClaims struct {
	jwt.MapClaims
	Uid string `json:"uid"`
}

// Если с токеном все хорошо,вызовется функция, которая находится внутри.
// Например для WithJWTAuth(handleHello) при правильном токене следом сработает handleHello
func WithJWTAuth(c *gin.Context) {
	// Получаем значение заголовка Authorization
	header := c.GetHeader("Authorization")

	// Проверяем не пустое ли значение в поле заголовка
	if header == "" {
		c.AbortWithStatusJSON(http.StatusUnauthorized, "Missing auth token")
		return
	}

	// Отделяем тип от токена(изначально у нас header выглядит так:
	//Bearer eyJhbGciOiJIU и так далее).
	tokenstring := strings.Split(header, " ")
	// Проверяем, что у нас есть и тип и сам токен
	if len(tokenstring) != 2 {
		c.AbortWithStatusJSON(http.StatusUnauthorized, "Invalid auth header")
		return
	}

	uid, err := ParseToken(tokenstring[1])
	if err != nil {
		c.AbortWithStatusJSON(http.StatusUnauthorized, err.Error())
		return
	}
	// Записываем uid в контекст, чтобы в дальнейшем использовать в других функциях
	c.Set("uid", uid)
}

// Создание токена
func GenerateJWT(uid string) (string, error) {
	claims := &tokenClaims{
		jwt.MapClaims{
			"ExpiresAt": time.Now().Add(4344 * time.Hour).Unix(), // Через сколько токен станет недействительный
			"IssuedAr":  time.Now().Unix(),                       // Время, когда был создан токен
		},
		uid,
	}
	// Создание токена с параметрами записанными в claims и uid пользователя
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	return token.SignedString([]byte(config.SigningKey))
}

// Создание access токена
func GenerateAccessToken(uid string) (string, error) {
	claims := &tokenClaims{
		jwt.MapClaims{
			"ExpiresAt": time.Now().Add(1 * time.Hour).Unix(), // Через сколько токен станет недействительный
			"IssuedAr":  time.Now().Unix(),                    // Время, когда был создан токен
		},
		uid,
	}
	// Создание токена с параметрами записанными в claims и uid пользователя
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	return token.SignedString([]byte(config.SigningKey))
}

// Создание refresh токена
func GenerateRefreshToken(uid string) (string, error) {
	claims := &tokenClaims{
		jwt.MapClaims{
			"ExpiresAt": time.Now().Add(724 * time.Hour).Unix(), // Через сколько токен станет недействительный
			"IssuedAr":  time.Now().Unix(),                      // Время, когда был создан токен
		},
		uid,
	}
	// Создание токена с параметрами записанными в claims и uid пользователя
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	return token.SignedString([]byte(config.SigningKey))
}

// Парсинг токена и получение uid пользователя
func ParseToken(tokenstring string) (string, error) {
	//Парсим токен, взяв из заголовка только токен
	token, err := jwt.ParseWithClaims(tokenstring, &tokenClaims{}, func(token *jwt.Token) (interface{}, error) {
		// Проверяем метод подписи токена
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("invalid signing method")
		}
		return []byte(config.SigningKey), nil
	})

	if err != nil {
		return "", err
	}

	// Проверяем что токен действителен
	if !token.Valid {
		return "", err
	}

	claims, ok := token.Claims.(*tokenClaims)
	if !ok {
		return "", err
	}

	if time.Now().Unix() > int64(claims.MapClaims["ExpiresAt"].(float64)) {
		return "Token has expired", errors.New("Token has expired")
	}

	return claims.Uid, nil
}

func RefreshTokens(c *gin.Context) {
	var requestBody struct {
		RefreshToken string `json:"refresh_token"`
	}

	err := c.BindJSON(&requestBody)
	if err != nil {
		c.JSON(http.StatusBadRequest, err.Error())
		fmt.Println("HandleWebSignIn:", err)
		return
	}

	uid, err := ParseToken(requestBody.RefreshToken)
	if err != nil {
		c.String(http.StatusInternalServerError, err.Error())
		fmt.Println("RefreshTokens:", err)
		return
	}

	refreshToken, err := GenerateRefreshToken(uid)
	if err != nil {
		c.String(http.StatusInternalServerError, err.Error())
		fmt.Println("RefreshTokens:", err)
		return
	}

	accessToken, err := GenerateAccessToken(uid)
	if err != nil {
		c.String(http.StatusInternalServerError, err.Error())
		fmt.Println("RefreshTokens:", err)
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"access_token":  accessToken,
		"refresh_token": refreshToken,
	})
}
