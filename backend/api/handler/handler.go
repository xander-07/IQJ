package handler

import (
	middleware2 "iqj/pkg/middleware"
	"iqj/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

const (
	DefaultRoute        = "/"
	NewsRoute           = "/news"
	AdvertisementsRoute = "/ad"
	LessonsRoute        = "/lessons"
	SignInRoute         = "/sign-in"
	SignUpRoute         = "/sign-up"
	WebSignInRoute      = "/web_sign-in"
	UpdateRoleRoute     = "/update_role"

	AuthGroupRoute = "/auth"

	FirebaseGroupRoute = "/firebase"
	FirebaseUserRoute  = "/user"
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
	r.GET(DefaultRoute, h.Hello)

	r.POST(SignUpRoute, h.HandleSignUp)
	r.POST(SignInRoute, h.HandleSignIn)
	r.POST(WebSignInRoute, h.HandleWebSignIn)

	r.GET(NewsRoute, h.HandleNews)

	r.GET(AdvertisementsRoute, h.HandleGetAdvertisement)

	r.GET(LessonsRoute, h.Lessons)

	// Группа функций, которая доступна только после аутентификации
	authGroup := r.Group(AuthGroupRoute)
	authGroup.Use(middleware2.WithJWTAuth)
	{
		authGroup.POST(NewsRoute, h.HandleAddNews)
		authGroup.PUT(NewsRoute, h.HandleUpdateNews)

		authGroup.POST(AdvertisementsRoute, h.HandlePostAdvertisement)
		authGroup.PUT(AdvertisementsRoute, h.HandleUpdateAdvertisements)

		authGroup.PUT(UpdateRoleRoute, h.HandleUpdateUserRole)

		// Группа функций для работы с Firebase
		firebaseGroup := authGroup.Group(FirebaseGroupRoute)
		{
			firebaseGroup.GET(FirebaseUserRoute, h.HandleListUsers)
			firebaseGroup.PUT(FirebaseUserRoute, h.HandleUpdateFirebaseUser)
		}
	}

	return r
}

func (h *Handler) Hello(c *gin.Context) {
	c.String(http.StatusOK, "Добро пожаловать в IQJ")
}
