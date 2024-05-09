package excelparser

import (
	"fmt"
	"iqj/config"
	"os"
	"path/filepath"
	"strings"

	"sync"

	"github.com/360EntSecGroup-Skylar/excelize"
)

func Parse2() error {
	id := 0
	institutes := []string{"/III", "/IIT", "/IKTST", "/IPTIP", "/IRI", "/ITKHT", "/ITU"}
	directory := config.DirToParse
	var wg sync.WaitGroup

	ch := make(chan int)

	for i := range institutes {
		path := directory + institutes[i]
		wg.Add(1)
		go Parse(path, &wg, ch, id)
	}

	go func() {
		wg.Wait()
		close(ch)
	}()

	return nil
}

// Парсинг всех Excel файлов директории
func Parse(path string, wg *sync.WaitGroup, ch chan int, id int) (int, error) {
	defer wg.Done()

	files, err := os.ReadDir(path)
	if err != nil {
		return id, err
	}

	for _, file := range files {
		if strings.HasSuffix(file.Name(), ".xlsx") {
			filePath := filepath.Join(path, file.Name())

			xlFile, err := excelize.OpenFile(filePath)
			if err != nil {
				fmt.Println("Ошибка открытия файла:", err)
				continue
			}

			table := xlFile.GetRows("Расписание занятий по неделям")
			id, err = find(table, id)
			if err != nil {
				fmt.Println("Ошибка при парсинге:", err)
				return id, err
			}
		}
	}

	ch <- id

	return id, nil
}
