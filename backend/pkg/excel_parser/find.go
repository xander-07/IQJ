package excel_parser

import (
	"iqj/database"
	"strconv"
)

// Получение критерия, значения и таблицы, возвращение массива уроков
func find(table [][]string, id int) (int, error) {
	//Индексы с названием дня недели (под индексом 3 - понедельник, 17 - вторник и т.д.)
	weekdayIndex := []int{3, 17, 31, 45, 59, 73, 87}
	//Срез ID групп
	var groupids []int
	//Срез названий групп
	var groups []string
	//Итераторы ID
	var groupid, teacherid int

	//Проход по всем строкам таблицы от 3 (начало расписания) до 88 (конец таблицы)
	for i := 3; i < 88; i++ {
		//group - одна группа типа StudentGroup
		group := &database.StudentGroup{}
		//row - одна пара типа Class
		var row database.Class
		//При нахождении строки между индексами weekdayIndex полю Weekday присваивается соответствующий индекс
		for k := 0; k < len(weekdayIndex); k++ {
			if weekdayIndex[k] > i {
				row.Weekday = k
				break
			}
		}
		//Итераторы прохода по таблице
		//так как некоторые пары стоят через 5 столбцов друг от друга, а некоторые через 10
		iter := 10
		count_iter := 0
		//Проход по столбцам таблицы от 5 (название пары) до конца строки
		for j := 5; j < len(table[3]); j += iter {
			//Если пары нет, итерация прекращается и меняются итераторы
			if table[i][j] == "" {
				if iter == 5 {
					iter = 10
					count_iter = 0
				} else {
					iter = 5
					count_iter = 5
				}
				continue
			}
			//Присваивание значений полям в соответствии с положением таблицы
			row.Id = id
			row.Count, _ = strconv.Atoi(table[i][j-4-count_iter])
			row.Teacher = teacherid
			row.TeacherName = table[i][j+2]
			if table[i][j-1-count_iter] == "I" {
				row.Week = 1
			} else {
				row.Week = 2
			}
			row.Name = table[i][j]
			row.Type = table[i][j+1]
			row.Location = table[i][j+3]
			//Поиск ID группы из БД
			group.Name = table[1][j]
			_, err := database.Database.StudentGroup.GetIdByName(group) // TODO: сделать группу вместо заглушки
			if err != nil {
				group.Id = 0
			}
			//Добавление группы и её ID в списки
			groupids = append(groupids, groupid)
			groups = append(groups, table[1][j])
			var teacher_iter int
			//Изменение итератора по учителю в соответствии с положением пары в группе
			//так как некоторые пары стоят через 5 столбцов друг от друга, а некоторые через 10
			if table[i][j-1] == "I" || table[i][j-1] == "II" {
				teacher_iter = 5
			} else {
				teacher_iter = 10
			}

			//Парсинг всех групп с одинаковой парой
			m := j
			//Пока у групп совпадают пары и учители
			//мы закидываем в список группы с совпадающими парами
			for m+2+iter < len(table[i]) && table[i][m+2] == table[i][m+2+teacher_iter] && table[i][m] == table[i][m+teacher_iter] {
				//Поиск ID группы из БД
				group.Name = table[1][m+teacher_iter]
				_, err := database.Database.StudentGroup.GetIdByName(group)
				if err != nil {
					group.Id = 0
				}
				//Добавление группы и её ID в списки
				groupids = append(groupids, groupid)
				groups = append(groups, table[1][m+teacher_iter])
				m += teacher_iter
				//Изменение итератора
				if teacher_iter == 5 {
					teacher_iter = 10
				} else {
					teacher_iter = 5
				}

			}
			//Присваивание полей групп и ID групп и обнуление список
			row.Groups = groupids
			row.GroupsNames = groups
			groupids = nil
			groups = nil
			//Добавление пары в БД
			err = database.Database.Class.Add(&row)
			if err != nil {
				return id, err
			}
			//Обновление итераторов
			id++
			teacherid++
			//Изменение итераторов
			if iter == 5 {
				iter = 10
				count_iter = 0
			} else {
				iter = 5
				count_iter = 5
			}
		}
	}
	return id, nil
}
