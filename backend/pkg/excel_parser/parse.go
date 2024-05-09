package excel_parser

import (
	"fmt"
	"iqj/config"
	"os"
	"path/filepath"
	"strings"

	"github.com/360EntSecGroup-Skylar/excelize"
)

// Парсинг всех Excel файлов директории
func Parse() error {
	id := 0
	institutes := []string{"/III", "/IIT", "/IKTST", "/IPTIP", "/IRI", "/ITKHT", "/ITU"}
	directory := config.DirToParse

	for i := range institutes {
		path := directory + institutes[i]
		files, err := os.ReadDir(path)
		if err != nil {
			return err
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
					return err
				}
			}
		}
	}

	return nil
}
