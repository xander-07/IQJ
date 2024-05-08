package firebase

import (
	"time"

	//"iqj/firebase"
	"log"

	"cloud.google.com/go/firestore"
	"golang.org/x/net/context"
)

type Message struct {
	Message     string    `json:"message"`
	ReceiverId  string    `json:"receiverId"`
	SenderEmail string    `json:"senderEmail"`
	SenderId    string    `json:"senderId"`
	Timestamp   time.Time `json:"timestamp"`
}

const (
	projectID = "iqj-uniapp"
)

func giveMessfirebase(mess Message) (*Message, error) {
	ctx := context.Background()
	client, err := firestore.NewClient(ctx, projectID)
	if err != nil {
		log.Fatal("error client %v", err)
		return nil, err
	}

	defer client.Close()

	_, _, err = client.Collection("posts").Add(ctx, map[string]interface{}{
		"Message":     mess.Message,
		"ReceiverId":  mess.ReceiverId,
		"SenderEmail": mess.SenderEmail,
		"SenderId ":   mess.SenderId,
		"Timestamp":   mess.Timestamp,
	})

	if err != nil {
		log.Fatal("firestor client error: %v", err)
		return nil, err
	}

	return mess, nil
}
