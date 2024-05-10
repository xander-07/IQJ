package excel_parser

import (
	"fmt"
	"iqj/config"
	"os"
	"path/filepath"
	"strings"

	"github.com/360EntSecGroup-Skylar/excelize"
)

// Парсинг всех Excel файлов
func Parse() error {
	id := 0
	institutes := []string{"/III", "/IIT", "/IKTST", "/IPTIP", "/IRI", "/ITKHT", "/ITU"}
	directory := config.DirToParse
	
	//Проход по всем институтам
	for i := range institutes {
		path := directory + institutes[i] //Добавление в директорию нужного института
		files, err := os.ReadDir(path)
		if err != nil {
			return err
		}

		//Проход по файлам директории института
		for _, file := range files {
			if strings.HasSuffix(file.Name(), ".xlsx") {
				filePath := filepath.Join(path, file.Name()) //Получение имени файла

				xlFile, err := excelize.OpenFile(filePath) //Открытие файла
				if err != nil {
					fmt.Println("Ошибка открытия файла:", err)
					continue
				}

				table := xlFile.GetRows("Расписание занятий по неделям") //Получение листа Excel
				id, err = find(table, id) //Получение нового ID и добавление одного файла в БД
				if err != nil {
					fmt.Println("Ошибка при парсинге:", err)
					return err
				}
			}
		}
	}

	return nil
}
