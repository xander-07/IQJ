package firebase

import (
	"fmt"
	"iqj/config"
	"iqj/firebase"
	"log"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"github.com/googleapis/enterprise-certificate-proxy/client"
	"golang.org/x/net/context"
	"google.golang.org/api/option"
)

type Message struct{
	ID int 
	Text string
	Sender auth.UserInfo
} 

const (
	projectID = "iqj-uniapp"
)

func giveMessfirebase(mess Message) (*Message,error){
	ctx := context.Background()
	client,err := firestore.NewClient(ctx,projectID)
	if (err!=nil){
		log.Fatal("error client %v",err)
		return nil,err
	}

	defer client.Close()

	_,_,err = client.Collection("posts").Add(ctx,map[string]interface{}{
		'ID': mess.ID,
		'Text': mess.Text,
		'Sender': mess.Sender,
	})

	if err!=nil{
		log.Fatal("firestor client error: %v",err)
		return nil,err
	}

	return mess,nil
}