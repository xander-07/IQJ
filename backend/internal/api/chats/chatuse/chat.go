package main

import (
	"database/sql"
	"fmt"

	//"os/user"

	//"fmt"
	"io"
	"log"
	"net/http"

	//"iqj/database/user_data.go"

	"github.com/gorilla/websocket"
	_ "github.com/lib/pq"
)

// потом заменить на то что находиться в бд (сейчас чет не импортироаволось)

type UserData struct {
	Id         int    `json:"id"`          // Уникальный идентификатор данных пользователя
	Name       string `json:"name"`        // Имя пользователя
	Bio        string `json:"bio"`         // Биография пользователя
	UsefulData string `json:"useful_data"` // Дополнительные данные пользователя
	Role       string `json:"role"`        // Роль пользователя в системе
}

type Message struct {
	text string
	user UserData
}

type Server struct {
	conns map[*websocket.Conn]bool
	db    *sql.DB
}

// func InsertMessage(name, message string) error {
// 	// Открытие соединения с базой данных PostgreSQL.
// 	db, err := sql.Open("postgres", "postgres://user:password@localhost:8080/database?sslmode=disable")
// 	if err != nil {
// 		return fmt.Errorf("ошибка при подключении к базе данных: %v", err)
// 	}
// 	defer db.Close()

// 	// Подготовка SQL-запроса для вставки данных в таблицу chat.
// 	query := "INSERT INTO chat (name, message) VALUES ($1, $2)"
// 	stmt, err := db.Prepare(query)
// 	if err != nil {
// 		return fmt.Errorf("ошибка при подготовке SQL-запроса: %v", err)
// 	}
// 	defer stmt.Close()

// 	// Выполнение SQL-запроса для вставки данных.
// 	_, err = stmt.Exec(name, message)
// 	if err != nil {
// 		return fmt.Errorf("ошибка при выполнении SQL-запроса: %v", err)
// 	}

// 	log.Println("Данные успешно добавлены в таблицу chat.")
// 	return nil
// }

func InsertMessage(mes Message) error {
	host := "localhost"
	port := 8080
	user := "postgres"
	password := "ghbdtn"
	dbname := "postgres"

	// Формирование строки подключения
	connStr := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	// Устанавливаем подключение к базе данных
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Database connection failed:", err)
	}

	err = db.Ping()
	if err != nil {
		panic(err)
	}

	defer db.Close()
	_, err = db.Exec("INSERT INTO chat (name, message) VALUES ($1, $2)", mes.user.Name, mes.text)
	if err != nil {
		panic(err)
	}
	return nil
}

func NewServer() *Server {
	host := "localhost"
	port := 8080
	user := "postgres"
	password := "ghbdtn"
	dbname := "postgres"

	// Формирование строки подключения
	connStr := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	// Устанавливаем подключение к базе данных
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Database connection failed:", err)
	}

	err = db.Ping()
	if err != nil {
		panic(err)
	}

	defer db.Close()
	return &Server{
		conns: make(map[*websocket.Conn]bool),
		db:    db,
	}
}

// func (s *Server) handlWS(ws *websocket.Conn) {
// 	fmt.Println("new connecting", ws.RemoteAddr())
// 	s.conns[ws] = true

// 	s.readLoop(ws)
// }

func (s *Server) handleWS(w http.ResponseWriter, r *http.Request) {
	// Инициализация соединения WebSocket.
	ws, err := websocket.Upgrade(w, r, nil, 1024, 1024)
	if err != nil {
		http.Error(w, "Failed to upgrade to WebSocket", http.StatusBadRequest)
		return
	}

	// Добавление подключения к серверу.
	s.conns[ws] = true

	// Запуск чтения сообщений из WebSocket.
	s.readLoop(ws)
}

func (s *Server) readLoop(ws *websocket.Conn) {
	var mes Message
	for {
		// Чтение сообщения из WebSocket.
		_, message, err := ws.ReadMessage()
		if err != nil {
			if err == io.EOF {
				break
			}
			log.Println("Read error:", err)
			continue
		}

		// Рассылка сообщения всем клиентам.
		s.broadcast(message)
		mes.text = string(message)
		mes.user.Name = "Vova"
		InsertMessage(mes)
	}
}

func (s *Server) broadcast(message []byte) {
	for conn := range s.conns {
		err := conn.WriteMessage(websocket.TextMessage, message)
		if err != nil {
			log.Println("Write error:", err)
		}
	}
}

func main() {
	host := "localhost"
	port := 8080
	user := "postgres"
	password := "ghbdtn"
	dbname := "postgres"

	// Формирование строки подключения
	connStr := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	// Устанавливаем подключение к базе данных
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Database connection failed:", err)
	}
	defer db.Close()

	// Выполняем запрос к таблице "chat"
	rows, err := db.Query("SELECT * FROM chat")
	if err != nil {
		panic(err)
	}
	defer rows.Close()

	//InsertMessage("petya", "Hello everyone")

	// // Обрабатываем результаты запроса
	// var chats []User
	// for rows.Next() {
	// 	var chat User
	// 	err := rows.Scan(&chat.id, &chat.name, &chat.message)
	// 	if err != nil {
	// 		panic(err)
	// 	}
	// 	chats = append(chats, chat)
	// }
	// if err = rows.Err(); err != nil {
	// 	panic(err)
	// }

	// // Выводим данные
	// for _, chat := range chats {
	// 	fmt.Printf("ID: %d, Name: %s, Message: %s\n", chat.id, chat.name, chat.message)
	// }

	// Проверяем подключение к базе данных
	err = db.Ping()
	if err != nil {
		panic(err)
	}

	// // Выполняем операцию INSERT
	// _, err = db.Exec("INSERT INTO chat (name, message) VALUES ($1, $2)", "Имя пользователя", "Пример сообщения")
	// if err != nil {
	// 	panic(err)
	// }

	// Создание сервера WebSocket.
	server := NewServer()

	// Зарегистрировать обработчик WebSocket.
	http.HandleFunc("/ws", server.handleWS)
	//http.Handle("/ws", websocket.Handler(server.handlWS))

	// Запуск HTTP сервера.
	log.Println("Server is running on http://localhost:8080/ws")
	err = http.ListenAndServe(":5037", nil)
	if err != nil {
		log.Fatal("Server startup failed:", err)
	}
}

// package main

// import (
// 	"fmt"
// 	"io"
// 	"net/http"

// 	//"github.com/gorilla/websocket"
// 	"golang.org/x/net/websocket"
// )

// type Server struct {
// 	conns map[*websocket.Conn]bool
// }

// func NewServer() *Server {
// 	return &Server{
// 		conns: make(map[*websocket.Conn]bool),
// 	}
// }

// func (s *Server) handlWS(ws *websocket.Conn) {
// 	fmt.Println("new connecting", ws.RemoteAddr())
// 	s.conns[ws] = true

// 	s.readLoop(ws)
// }

// func (s *Server) readLoop(ws *websocket.Conn) {
// 	buf := make([]byte, 1024)
// 	for {
// 		n, err := ws.Read(buf)
// 		if err != nil {
// 			if err == io.EOF {
// 				break
// 			}
// 			fmt.Println("read error", err)
// 			continue
// 		}
// 		msg := buf[:n]
// 		// fmt.Println(string(msg))
// 		// ws.Write([]byte("u writed a msg"))
// 		s.broadcast(msg)
// 	}
// }

// func (s *Server) broadcast(b []byte) {
// 	for ws := range s.conns {
// 		go func(ws *websocket.Conn) {
// 			if _, err := ws.Write(b); err != nil {
// 				fmt.Println("write error", err)
// 			}
// 		}(ws)
// 	}
// }

// func main() {
// 	server := NewServer()
// 	http.Handle("/ws", websocket.Handler(server.handlWS))
// 	http.ListenAndServe(":5037", nil)
// }

// package main

// import (
// 	"fmt"
// 	"log"
// 	"net/http"
// )

// func main() {
// 	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
// 		fmt.Fprint(w, "Привет, мир!")
// 	})

// 	log.Println("Сервер запущен на http://localhost:8080")
// 	err := http.ListenAndServe(":5037", nil)
// 	if err != nil {
// 		log.Fatal("Ошибка при запуске сервера:", err)
// 	}
// }
