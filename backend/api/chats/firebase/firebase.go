package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"

	"cloud.google.com/go/firestore"
	"google.golang.org/api/option"

	firebase "firebase.google.com/go"
)

func main() {
	_, err := createClient()
	if err != nil {
		log.Printf("error client %v", err)
		return
	}

	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Hello, World!")
	})
	r.GET("/api/health", HealthCheckHandler())
	// r.Run("127.0.0.1:5050")
}

type Mess struct {
	ID      string
	Message string
}

func CreateMessHandler(client *firestore.Client) func(c *gin.Context) {
	return func(c *gin.Context) {
		var mess Mess.Todo
		if err := c.BindJSON(&mess); err != nil {
			c.AbortWithStatusJSON(http.StatusBadReauest, gin.H{"error": err.Error()})
			return
		}
		now := time.Now()

		ref := client.Collection()
	}

}

func HealthCheckHandler() func(c *gin.Context) {
	return func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"ok": true})
	}
}

func createClient() (*firestore.Client, error) {
	ctx := context.Background()
	//conf := &firebase.Config{ProjectID: "iqj-uniapp"}
	opt := option.WithCredentialsFile("C:/Users/ddm22/Downloads/iqj-uniapp-firebase-adminsdk-78svx-69c52bf7c6.json")
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		fmt.Errorf("error initializing app: %v", err)
		return nil, err
	}
	// app, err := firebase.NewApp(ctx, conf)

	// if err != nil {
	// 	log.Printf("error: %v", err)
	// 	return
	// }

	client, err := app.Firestore(ctx)
	if err != nil {
		log.Printf("error create client")
		log.Fatal(err)
	}

	return client, nil

	// ref := client.Collection("some_exp").NewDoc()
	// result, err := ref.Set(ctx, map[string]interface{}{
	// 	"adress":  "a random human",
	// 	"message": "Hi",
	// })

	// if err != nil {
	// 	log.Printf("error %v", err)
	// 	log.Fatal(err)
	// }

	// log.Printf("result is %v", result)
}

// package main

// import (
// 	"context"
// 	"log"

// 	firebase "firebase.google.com/go"
// 	"google.golang.org/api/option"
// )

// func main() {
// 	ctx := context.Background()

// 	// Путь к файлу с приватными ключами
// 	sa := option.WithCredentialsFile("path/to/serviceAccountKey.json")

// 	// Инициализация приложения с использованием файла приватных ключей и ProjectID
// 	app, err := firebase.NewApp(ctx, &firebase.Config{
// 		ProjectID: "iqj-uniapp",
// 	}, sa)
// 	if err != nil {
// 		log.Fatalf("error initializing app: %v", err)
// 	}

// 	client, err := app.Firestore(ctx)
// 	if err != nil {
// 		log.Printf("error create client")
// 		log.Fatal(err)
// 	}

// 	ref := client.Collection("some_exp").NewDoc()
// 	result, err := ref.Set(ctx, map[string]interface{}{
// 		"adress":  "a random human",
// 		"message": "Hi",
// 	})

// 	if err != nil {
// 		log.Printf("error %v", err)
// 		log.Fatal(err)
// 	}

// 	log.Printf("result is %v", result)

// }
