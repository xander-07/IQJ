package middleware

import (
	"errors"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"iqj/config"
	"net/http"
	"strings"
	"time"
)

// Структура для параметров JWT
type tokenclaims struct {
	jwt.MapClaims
	UserId int `json:"user_id"`
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
	// Записываем id в контекст, чтобы в дальнейшем использовать в других функциях
	c.Set("uid", uid)
}

// Создание токена
func GenerateJWT(id int) (string, error) {
	claims := &tokenclaims{
		jwt.MapClaims{
			"ExpiresAt": time.Now().Add(4344 * time.Hour).Unix(), // Через сколько токен станет недействительный
			"IssuedAr":  time.Now().Unix(),                       // Время, когда был создан токен
		},
		id,
	}
	// Создание токена с параметрами записанными в claims и id пользователя
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	return token.SignedString([]byte(config.SigningKey))
}

// Парсинг токена и получение id пользователя
func ParseToken(tokenstring string) (int, error) {
	//Парсим токен, взяв из заголовка только токен
	token, err := jwt.ParseWithClaims(tokenstring, &tokenclaims{}, func(token *jwt.Token) (interface{}, error) {
		// Проверяем метод подписи токена
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("invalid signing method")
		}
		return []byte(config.SigningKey), nil
	})

	if err != nil {
		return 0, err
	}

	// Проверяем что токен действителен
	if !token.Valid {
		return 0, err
	}

	claims, ok := token.Claims.(*tokenclaims)
	if !ok {
		return 0, err
	}

	return claims.UserId, nil
}
