package handler

import (
	"iqj/internal/service"
	"iqj/pkg/middleware"
	"net/http"

	"github.com/gin-gonic/gin"
)

const (
	DefaultRoute = "/"

	NewsRoute  = "/news"
	NewsSearch = "/news_search"
	NewsTags   = "/news_tags"
	NewsDate   = "/news_date"

	AdvertisementsRoute    = "/ad"
	AllAdvertisementsRoute = "/ad_all"

	LessonsRoute = "/lessons"

	SignInRoute     = "/sign-in"
	SignUpRoute     = "/sign-up"
	WebSignInRoute  = "/web_sign-in"
	UpdateRoleRoute = "/update_role"

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
	r.Use(middleware.CORSMiddleware())

	// Вызов хэндлеров исходя из запроса.
	r.GET(DefaultRoute, h.Hello)

	r.POST(SignUpRoute, h.HandleSignUp)
	r.POST(SignInRoute, h.HandleSignIn)
	r.POST(WebSignInRoute, h.HandleWebSignIn)

	r.GET(NewsRoute, h.HandleNews)
	r.GET(NewsSearch, h.HandleSearchNews)
	r.GET(NewsTags, h.HandleSearchNewsByTags)
	r.GET(NewsDate, h.HandleSearchNewsByDate)

	r.GET(AdvertisementsRoute, h.HandleGetAdvertisement)
	r.GET(AllAdvertisementsRoute, h.HandleGetAllAdvertisements)

	r.GET(LessonsRoute, h.Lessons)

	// Группа функций, которая доступна только после аутентификации
	authGroup := r.Group(AuthGroupRoute)
	authGroup.Use(middleware.WithJWTAuth)
	{
		authGroup.POST(NewsRoute, h.HandleAddNews)
		authGroup.PUT(NewsRoute, h.HandleUpdateNews)
		authGroup.DELETE(NewsRoute, h.HandleDeleteNews)

		authGroup.POST(AdvertisementsRoute, h.HandlePostAdvertisement)
		authGroup.PUT(AdvertisementsRoute, h.HandleUpdateAdvertisements)
		authGroup.DELETE(AdvertisementsRoute, h.HandleDeleteAdvertisement)

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
