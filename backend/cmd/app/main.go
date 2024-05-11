package main

import (
	"iqj/internal/api/handler"
	"iqj/internal/database"
	"iqj/internal/service"
	"iqj/pkg/excel_parser"
	"iqj/pkg/news_parser"
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

	// Запускает парсер расписания
	go excel_parser.Parse()

	// Запускает сервер на порту и "слушает" запросы.
	if err := handlers.InitRoutes().Run(":8443"); err != nil {
		log.Fatal(err)
	}
}