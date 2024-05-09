package excel_parser

import (
	"iqj/database"
	"strconv"
)

// Получение критерия, значения и таблицы, возвращение массива уроков
func find(table [][]string, id int) (int, error) {
	weekdayIndex := []int{3, 17, 31, 45, 59, 73, 87}
	var groupids []int
	var groups []string
	var teacherid int

	for i := 3; i < 88; i++ {
		group := &database.StudentGroup{}
		var row database.Class
		for k := 0; k < len(weekdayIndex); k++ {
			if weekdayIndex[k] > i {
				row.Weekday = k
				break
			}
		}
		iter := 10
		count_iter := 0
		for j := 5; j < len(table[3]); j += iter {
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
			group.Name = table[1][j]
			group, err := database.Database.StudentGroup.GetIdByName(group)
			if err != nil {
				return id, err
			}
			groupids = append(groupids, group.Id)
			groups = append(groups, table[1][j])
			var teacher_iter int
			if table[i][j-1] == "I" || table[i][j-1] == "II" {
				teacher_iter = 5
			} else {
				teacher_iter = 10
			}

			m := j
			for m+2+iter < len(table[i]) && table[i][m+2] == table[i][m+2+teacher_iter] && table[i][m] == table[i][m+teacher_iter] {
				group.Name = table[1][m+teacher_iter]
				group, err := database.Database.StudentGroup.GetIdByName(group)
				if err != nil {
					return id, err
				}
				groupids = append(groupids, group.Id)
				groups = append(groups, table[1][m+teacher_iter])
				m += teacher_iter
				if teacher_iter == 5 {
					teacher_iter = 10
				} else {
					teacher_iter = 5
				}

			}
			row.Groups = groupids
			row.GroupsNames = groups
			groupids = nil
			groups = nil
			err = database.Database.Class.Add(&row)
			if err != nil {
				return id, err
			}
			id++
			teacherid++
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
