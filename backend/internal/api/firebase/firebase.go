package firebase

import (
	"fmt"
	"iqj/config"

	firebase "firebase.google.com/go/v4"
	"golang.org/x/net/context"
	"google.golang.org/api/option"
)

// Инициализация firebase
func InitFirebase() *firebase.App {
	opt := option.WithCredentialsFile(config.OptPath)

	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		fmt.Printf("InitFirebase: error initializing app: %v\n", err)
		return nil
	}

	return app
}
