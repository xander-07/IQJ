package main

import (
	"iqj/api/handler"
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.GET("/lessons", handler.Lessons)

	if err := r.Run(":8443"); err != nil {
		log.Fatal(err)
	}
}
