package excelparser

import (
	"fmt"
	"iqj/config"
	"iqj/models"
	"os"
	"path/filepath"
	"strings"
	"sync"

	"github.com/360EntSecGroup-Skylar/excelize"
)

func Parse2(criterion, value string) ([]models.Lesson, error) {
	var wg sync.WaitGroup

	institutes := []string{"/III", "/IIT", "/IKTST", "/IPTIP", "/IRI", "/ITKHT", "/ITU"}
	directory := config.DirToParse //ПРОПИСАТЬ ПОЛНЫЙ ПУТЬ, ЕСЛИ НЕ РАБОТАЕТ

	ch := make(chan []models.Lesson)

	for i := range institutes {
		path := directory + institutes[i]
		wg.Add(1)
		go Parse(criterion, value, path, &wg, ch)
	}

	var result []models.Lesson

	go func() {
		wg.Wait()
		close(ch)
	}()

	for i := range ch {
		result = append(result, i...)
	}

	return result, nil
}

// Парсинг всех Excel файлов директории
func Parse(criterion, value, path string, wg *sync.WaitGroup, ch chan []models.Lesson) ([]models.Lesson, error) {
	defer wg.Done()

	var tables []models.Lesson
	files, err := os.ReadDir(path)
	if err != nil {
		return tables, err
	}

	id := 0
	for _, file := range files {
		if strings.HasSuffix(file.Name(), ".xlsx") {
			filePath := filepath.Join(path, file.Name())

			xlFile, err := excelize.OpenFile(filePath)
			if err != nil {
				fmt.Println("Ошибка открытия файла:", err)
				continue
			}

			table := xlFile.GetRows("Расписание занятий по неделям")
			var newTable []models.Lesson
			newTable, id, err = find(criterion, value, table, id)
			if err != nil {
				fmt.Println("Ошибка при парсинге:", err)
				return nil, err
			}
			for _, lesson := range newTable {
				tables = append(tables, lesson)
			}
		}
	}

	ch <- tables

	return tables, nil
}
