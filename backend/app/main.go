package main

import (
	"iqj/api/handler"
	"iqj/api/scraper"
	"iqj/config"
	"iqj/database"
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
	go scraper.ScrapTick()

	// Запускает сервер на порту и "слушает" запросы.
	if err := handlers.InitRoutes().RunTLS(":8443", config.SertificatePath, config.KeyPath); err != nil {
		log.Fatal(err)
	}
}
