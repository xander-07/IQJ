package main

import (
	"iqj/api/handler"
	"iqj/config"
	"iqj/database"
	"iqj/pkg/news_parser"
	"iqj/service"
	"log"
)

func main() {
	// БД
	database.NewDatabaseInstance()

	repository := database.NewRepository()
	services := service.NewService(repository)
	handlers := handler.NewHandler(services)

	// Запускает парсер новостей
	go news_parser.ScrapTick()

	// Запускает сервер на порту и "слушает" запросы.
	if err := handlers.InitRoutes().RunTLS(":8443", config.SertificatePath, config.KeyPath); err != nil {
		log.Fatal(err)
	}
}
