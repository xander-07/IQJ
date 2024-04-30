package excelparser

import (
	"strconv"
	"strings"
)

type Lesson struct {
	Id         int      `json:"class_id"`                  // Id пары
	GroupID    []string `json:"class_group_ids,omitempty"` // ЗАМЕНИТЬ НА []string //Список Id групп, для которых пара
	TeacherID  string   `json:"class_teacher_id"`          // ЗАМЕНИТЬ НА string //Id преподавателя, который ведет пару
	Count      int      `json:"class_count"`               // Какая пара по счету за день
	Weekday    int      `json:"class_weekday"`             // Номер дня недели
	Week       int      `json:"class_week"`                // Номер учебной неделяя
	LessonName string   `json:"class_name"`                // Название пары
	LessonType string   `json:"class_type"`                // Тип пары
	Location   string   `json:"class_location"`            // Местонахождение
}

// Получение критерия, значения и таблицы, возвращение массива уроков
func find(criterion string, value string, table [][]string, id int) ([]Lesson, int, error) {
	var valueTable []Lesson
	weekdayIndex := []int{3, 17, 31, 45, 59, 73, 87}
	var groupid []string //ЗАМЕНИТЬ НА []string
	//Поиск по группе
	if criterion == "group" {
		n := 0
		// Запоминание номера столбца с нужной группой
		for i := 0; i < len(table[1]); i++ {
			if table[1][i] == value {
				n = i
				break
			}
		}
		if n == 0 {
			return nil, id, nil
		}

		for i := 3; i < 88; i++ {
			if table[i][n] == "" {
				continue
			}
			var row Lesson
			for j := 0; j < len(weekdayIndex); j++ {
				if weekdayIndex[j] > i {
					row.Weekday = j
					break
				}
			}
			//groupid = append(groupid, 0) //ЗАМЕНИТЬ НА groupid = append(groupid, table[1][n]) //TODO: Заменить на поиск из БД
			groupid = append(groupid, table[1][n])
			var iter int
			if table[i][n-1] == "I" || table[i][n-1] == "II" {
				iter = 5
				row.Count, _ = strconv.Atoi(table[i][n-4])
				if table[i][n-1] == "I" {
					row.Week = 1
				} else {
					row.Week = 2
				}
			} else {
				iter = 10
				row.Count, _ = strconv.Atoi(table[i][n-9])
				if table[i][n-6] == "I" {
					row.Week = 1
				} else {
					row.Week = 2
				}
			}
			m := n
			for m+2+iter < len(table[i]) && table[i][m+2] == table[i][m+2+iter] && table[i][m] == table[i][m+iter] {
				//groupid = append(groupid, 0) //ЗАМЕНИТЬ НА groupid = append(groupid, table[1][m+iter]) //TODO: Заменить на поиск из БД
				groupid = append(groupid, table[1][m+iter])
				m += iter
				if iter == 5 {
					iter = 10
				} else {
					iter = 5
				}
			}
			row.Id = id
			row.GroupID = groupid
			groupid = nil
			//row.TeacherID = 0 //ЗАМЕНИТЬ НА row.TeacherID = table[i][n+2] //TODO: Заменить на поиск из БД
			row.TeacherID = table[i][n+2]
			row.LessonName = table[i][n]
			row.LessonType = table[i][n+1]
			row.Location = table[i][n+3]

			valueTable = append(valueTable, row)
			id++
		}
		//Поиск по преподавателю
	} else if criterion == "tutor" {
		var pairs [][]int
		var pair []int
		iter := 5
		// Запоминание ячеек с именем препода
		for i := 0; i < 87; i++ {
			for j := 7; j < len(table[2]); j += iter {
				if (strings.Contains(table[i][j], value) && strings.Contains(table[i][j], "\n")) || table[i][j] == value {
					pair = append(pair, i, j)
					pairs = append(pairs, pair)
					pair = nil
				}
				// Парсинг в зависимости от положения группы в таблице
				if iter == 5 {
					iter = 10
				} else {
					iter = 5
				}
			}
		}
		if len(pairs) == 0 {
			return nil, id, nil
		}
		var rowNum int
		var colNum int
		// Закидывание инфы о паре
		for i := 0; i < len(pairs); i++ {
			rowNum = pairs[i][0]
			colNum = pairs[i][1]
			if table[rowNum][colNum-2] == "" {
				continue
			}
			var row Lesson
			for j := 0; j < len(weekdayIndex); j++ {
				if weekdayIndex[j] > rowNum {
					row.Weekday = j
					break
				}
			}

			//groupid = append(groupid, 0) //ЗАМЕНИТЬ НА groupid = append(groupid, table[1][colNum-2])
			groupid = append(groupid, table[1][colNum-2])

			m := colNum
			// Парсинг групп с одинаковыми парами в зависимости от положения группы в таблице
			if table[rowNum][colNum-3] == "I" || table[rowNum][colNum-3] == "II" {
				iter := 5
				for m-2+iter < len(table[rowNum]) && table[rowNum][m] == table[rowNum][m+iter] && table[rowNum][m-2] == table[rowNum][m-2+iter] {

					//groupid = append(groupid, 0) //ЗАМЕНИТЬ НА groupid = append(groupid, table[1][m-2+iter]) //TODO: Заменить на поиск из БД
					groupid = append(groupid, table[1][m-2+iter])

					m += iter
					if iter == 5 {
						iter = 10
					} else {
						iter = 5
					}
				}
				row.Count, _ = strconv.Atoi(table[rowNum][colNum-6])
				if table[rowNum][colNum-3] == "I" {
					row.Week = 1
				} else {
					row.Week = 2
				}
			} else {
				iter := 10
				for m+iter < len(table[rowNum]) && table[rowNum][m] == table[rowNum][m+iter] && table[rowNum][m-2] == table[rowNum][m-2+iter] {

					//groupid = append(groupid, 0) //ЗАМЕНИТЬ НА groupid = append(groupid, table[1][m-2+iter]) //TODO: Заменить на поиск из БД
					groupid = append(groupid, table[1][m-2+iter])

					m += iter
					if iter == 5 {
						iter = 10
					} else {
						iter = 5
					}
				}
				row.Count, _ = strconv.Atoi(table[rowNum][colNum-11])
				if table[rowNum][colNum-8] == "I" {
					row.Week = 1
				} else {
					row.Week = 2
				}
			}
			row.Id = id
			row.GroupID = groupid
			groupid = nil

			//row.TeacherID = 0 //ЗАМЕНИТЬ НА row.TeacherID = table[rowNum][colNum] //TODO: Заменить на поиск из БД
			row.TeacherID = table[rowNum][colNum]

			row.LessonName = table[rowNum][colNum-2]
			row.LessonType = table[rowNum][colNum-1]
			row.Location = table[rowNum][colNum+1]
			valueTable = append(valueTable, row)
			id++
		}
		//Поиск по аудитории
		//см. поиск по преподу
	} else if criterion == "classroom" {
		var pairs [][]int
		var pair []int
		iter := 5
		for i := 0; i < 87; i++ {
			for j := 8; j < len(table[2]); j += iter {
				if (strings.Contains(table[i][j], value) && strings.Contains(table[i][j], "\n")) || table[i][j] == value {
					pair = append(pair, i, j)
					pairs = append(pairs, pair)
					pair = nil
				}
				if iter == 5 {
					iter = 10
				} else {
					iter = 5
				}
			}
		}
		if len(pairs) == 0 {
			return nil, id, nil
		}
		var rowNum int
		var colNum int
		for i := 0; i < len(pairs); i++ {
			rowNum = pairs[i][0]
			colNum = pairs[i][1]
			if table[rowNum][colNum-3] == "" {
				continue
			}
			var row Lesson
			for j := 0; j < len(weekdayIndex); j++ {
				if weekdayIndex[j] > rowNum {
					row.Weekday = j
					break
				}
			}
			m := colNum

			//groupid = append(groupid, 0) // ЗАМЕНИТЬ НА groupid = append(groupid, table[1][colNum-3])
			groupid = append(groupid, table[1][colNum-3])

			if table[rowNum][colNum-4] == "I" || table[rowNum][colNum-4] == "II" {
				iter := 5
				for m+iter < len(table[rowNum]) && table[rowNum][m] == table[rowNum][m+iter] && table[rowNum][m-3] == table[rowNum][m-3+iter] {

					//groupid = append(groupid, 0) //ЗАМЕНИТЬ НА groupid = append(groupid, table[1][m-3+iter]) //TODO: Заменить на поиск из БД
					groupid = append(groupid, table[1][m-3+iter])

					m += iter
					if iter == 5 {
						iter = 10
					} else {
						iter = 5
					}
				}
				row.Count, _ = strconv.Atoi(table[rowNum][colNum-7])
				if table[rowNum][colNum-4] == "I" {
					row.Week = 1
				} else {
					row.Week = 2
				}
			} else {
				iter := 10
				for m+iter < len(table[rowNum]) && table[rowNum][m] == table[rowNum][m+iter] && table[rowNum][m-3] == table[rowNum][m-3+iter] {

					//groupid = append(groupid, 0) //ЗАМЕНИТЬ НА groupid = append(groupid, table[1][m-3+iter]) //TODO: Заменить на поиск из БД
					groupid = append(groupid, table[1][m-3+iter])

					m += iter
					if iter == 5 {
						iter = 10
					} else {
						iter = 5
					}
				}
				row.Count, _ = strconv.Atoi(table[rowNum][colNum-12])
				if table[rowNum][colNum-9] == "I" {
					row.Week = 1
				} else {
					row.Week = 2
				}
			}
			row.Id = id
			row.GroupID = groupid // //TODO: Заменить на поиск из БД
			groupid = nil

			//row.TeacherID = 0 //ЗАМЕНИТЬ НА row.TeacherID = table[rowNum][colNum-1] //TODO: Заменить на поиск из БД
			row.TeacherID = table[rowNum][colNum-1]

			row.LessonName = table[rowNum][colNum-3]
			row.LessonType = table[rowNum][colNum-2]
			row.Location = table[rowNum][colNum]
			valueTable = append(valueTable, row)
			id++
		}
	}

	return valueTable, id, nil
}
