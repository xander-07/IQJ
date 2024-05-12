package middleware

import (
	"github.com/gin-gonic/gin"
)

// Middleware, который позволяет клиентам с разных источников безопасно взаимодействовать с вашим API.
// Он устанавливает необходимые заголовки CORS в HTTP-ответах.
func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		origin := c.GetHeader("Origin")
		c.Writer.Header().Set("Access-Control-Allow-Origin", origin)
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Origin, Content-Type")

		// Проверка на предварительный запрос с методом OPTIONS.
		// Если это предварительный запрос, обработчик отправляет ответ со статусом 200 OK и возвращает управление.
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		// Для всех остальных запросов вызывается следующий обработчик в цепочке.
		c.Next()
	}
}
