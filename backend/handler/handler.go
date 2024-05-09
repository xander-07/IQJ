package handler

import (
	middleware2 "iqj/pkg/middleware"
	"iqj/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

type Handler struct {
	services *service.Service
}

func NewHandler(services *service.Service) *Handler {
	return &Handler{services: services}
}

// Функция для создания роутера, добавления к нему CORSMiddleware
// и объявления путей для всех запросов.
func (h *Handler) InitRoutes() *gin.Engine {
	r := gin.Default()

	// Добавляет заголовки CORS к ответам сервера.
	// Необходимо для того, чтобы клиентские приложения,
	// работающие на других доменах, могли взаимодействовать с API.
	r.Use(middleware2.CORSMiddleware())

	// Вызов хэндлеров исходя из запроса.
	r.GET("/", h.Hello)

	r.POST("/sign-up", h.HandleSignUp)
	r.POST("/sign-in", h.HandleSignIn)
	r.POST("/web_sign-in", h.HandleWebSignIn)

	r.GET("/news", h.HandleGetNews)
	r.GET("/news_id", h.HandleGetNewsById)

	r.GET("/ad", h.HandleGetAdvertisement)

	r.GET("/lessons", h.Lessons)

	// Группа функций, которая доступна только после аутентификации
	authGroup := r.Group("/api")
	authGroup.Use(middleware2.WithJWTAuth)
	{
		authGroup.POST("/news", h.HandleAddNews)

		authGroup.POST("/ad", h.HandlePostAdvertisement)
		authGroup.PUT("/ad", h.HandleUpdateAdvertisements)

		authGroup.PUT("/update_role", h.HandleUpdateUserRole)

		// // Группа функций для работы с Firebase
		firebaseGroup := authGroup.Group("/firebase")
		{
			firebaseGroup.GET("/list_user", h.HandleListUsers)
		}
	}

	return r
}

func (h *Handler) Hello(c *gin.Context) {
	c.String(http.StatusOK, "Добро пожаловать в IQJ")
}
