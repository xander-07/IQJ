package firebase

import (
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"fmt"
	"golang.org/x/net/context"
	"google.golang.org/api/option"
	"iqj/config"
)

// Инициализация firebase
func InitFirebase() (*auth.Client, error) {
	opt := option.WithCredentialsFile(config.OptPath)

	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		fmt.Println("InitFirebase: error initializing app: %v\n", err)
		return nil, err
	}

	client, err := app.Auth(context.Background())
	if err != nil {
		fmt.Println("InitFirebase: error getting Auth client: %v\n", err)
		return nil, err
	}

	return client, nil
}
