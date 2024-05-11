package database

// import (
// 	"database/sql"
// 	"errors"
// 	"fmt"

// 	"github.com/lib/pq"
// )

// // Dialogue представляет сущность диалога в системе.
// type Dialogue struct {
// 	Id           int   `json:"id"`           // Уникальный идентификатор диалога
// 	Participants []int `json:"participants"` // Участники диалога
// 	Moderators   []int `json:"moderators"`   // Модераторы диалога
// }

// func (d *Dialogue) isDefault() bool {
// 	return d.Id == 0 && d.Moderators == nil && d.Participants == nil
// }

// // DialogueTable предоставляет методы для работы с таблицей диалогов в базе данных.
// type DialogueTable struct {
// 	db *sql.DB          // Указатель на подключение к базе данных
// 	tm transactionMaker // Создатель транзакций
// }

// // GetAvaliable возвращает все айди диалогов, в которых участвует пользователь с данным айди.
// func (dt *DialogueTable) GetAvaliable(u *User) ([]int, error) {
// 	if u.isDefault() {
// 		return nil, errors.New("Dialogue.GetAvaliable: provided *User is empty!")
// 	}
// 	rows, err := dt.tm.makeSelect(dt.db, "SELECT dialogue_id FROM dialogues WHERE $1 = ANY(participants)", u.Id)
// 	if err != nil {
// 		return nil, fmt.Errorf("Dialogue.GetAvaliable: %v", err)
// 	}
// 	defer rows.Close()

// 	var dialogues []int
// 	for rows.Next() {
// 		var dialogueId int
// 		if err := rows.Scan(&dialogueId); err != nil {
// 			return nil, fmt.Errorf("Dialogue.GetAvaliable: %v", err)
// 		}
// 		dialogues = append(dialogues, dialogueId)
// 	}

// 	return dialogues, nil
// }

// // AddParticipant добавляет пользователя в диалог по указанному айди.
// func (dt *DialogueTable) AddParticipant(d *Dialogue, u *User) error {
// 	if u.isDefault() || d.isDefault() {
// 		return errors.New("Dialogue.AddParticipant: provided data is empty!")
// 	}

// 	err := dt.tm.makeUpdate(dt.db, "UPDATE dialogues SET participants = array_append(participants, $1) WHERE dialogue_id = $2", u.Id, d.Id)
// 	if err != nil {
// 		return fmt.Errorf("Dialogue.AddParticipant: %v", err)
// 	}
// 	return nil
// }

// // RemoveParticipant удаляет пользователя из диалога по указанному айди.
// // Также проверяет наличие прав модератора у удаляющего.
// func (dt *DialogueTable) RemoveParticipant(dialogueId, userId, requesterId int) error {
// 	// Проверяем является ли запросивший участник модератором диалога
// 	rows, err := dt.tm.makeSelect(dt.db, "SELECT moderators FROM dialogues WHERE dialogue_id = $1 AND $2 = ANY(moderators)", dialogueId, requesterId)
// 	if err != nil {
// 		return fmt.Errorf("Dialogue.RemoveParticipant: %v", err)
// 	}
// 	defer rows.Close()

// 	var moderatorFound bool
// 	for rows.Next() {
// 		moderatorFound = true
// 		break
// 	}

// 	if !moderatorFound {
// 		return errors.New("Dialogue.RemoveParticipant: requester is not a moderator")
// 	}

// 	// Удаляем пользователя из диалога
// 	err = dt.tm.makeUpdate(dt.db, "UPDATE dialogues SET participants = array_remove(participants, $1) WHERE dialogue_id = $2", userId, dialogueId)
// 	if err != nil {
// 		return fmt.Errorf("Dialogue.RemoveParticipant: %v", err)
// 	}
// 	return nil
// }

// // AddModerator добавляет модератора в диалог по указанному айди.
// func (dt *DialogueTable) AddModerator(dialogueId, userId int) error {
// 	err := dt.tm.makeUpdate(dt.db, "UPDATE dialogues SET moderators = array_append(moderators, $1) WHERE dialogue_id = $2", userId, dialogueId)
// 	if err != nil {
// 		return fmt.Errorf("Dialogue.AddModerator: %v", err)
// 	}
// 	return nil
// }

// // RemoveModerator удаляет модератора из диалога по указанному айди.
// func (dt *DialogueTable) RemoveModerator(dialogueId, userId int) error {
// 	err := dt.tm.makeUpdate(dt.db, "UPDATE dialogues SET moderators = array_remove(moderators, $1) WHERE dialogue_id = $2", userId, dialogueId)
// 	if err != nil {
// 		return fmt.Errorf("Dialogue.RemoveModerator: %v", err)
// 	}
// 	return nil
// }

// // GetParticipants возвращает всех пользователей в диалоге по указанному айди.
// func (dt *DialogueTable) GetParticipants(dialogueId int) ([]int, error) {
// 	rows, err := dt.tm.makeSelect(dt.db, "SELECT participants FROM dialogues WHERE dialogue_id = $1", dialogueId)
// 	if err != nil {
// 		return nil, fmt.Errorf("Dialogue.GetParticipants: %v", err)
// 	}
// 	defer rows.Close()

// 	var participants []int
// 	if rows.Next() {
// 		if err := rows.Scan(pq.Array(&participants)); err != nil {
// 			return nil, fmt.Errorf("Dialogue.GetParticipants: %v", err)
// 		}
// 	}

// 	return participants, nil
// }
