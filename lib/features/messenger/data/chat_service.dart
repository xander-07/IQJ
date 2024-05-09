import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iqj/features/messenger/domain/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(String receiverId, String message) async {
    // get info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create msg
    final Message newMessage = Message(

      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    // make chatroom
    final List<String> ids = [currentUserId, receiverId];
    ids.sort();
    print(ids);
    final String chatRoomId = ids.join("_");

    // add to db
    await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // Future<void> sendMessFile(String receiverId, File message) async {
  //   // get info
  //   final String currentUserId = _auth.currentUser!.uid;
  //   final String currentUserEmail = _auth.currentUser!.email.toString();
  //   final Timestamp timestamp = Timestamp.now();

  //   // create msg
  //   // final Message newMessage = Message(
  //   //   senderId: currentUserId,
  //   //   senderEmail: currentUserEmail,
  //   //   receiverId: receiverId,
  //   //   timestamp: timestamp,
  //   //   message: message,
  //   // );
  //   final FileMes newFile = FileMes(
  //     senderId: currentUserId, 
  //     senderEmail: currentUserId, 
  //     receiverId: receiverId, 
  //     message: message, 
  //     timestamp: timestamp);

  //   // make chatroom
  //   final List<String> ids = [currentUserId, receiverId];
  //   ids.sort();
  //   print(ids);
  //   final String chatRoomId = ids.join("_");

  //   // add to db
  //   await _firestore
  //       .collection('chatrooms')
  //       .doc(chatRoomId)
  //       .collection('messages')
  //       .add(newFile.toMap());
  // }
// Future<String> uploadImage(File imageFile) async {
//   FirebaseStorage storage = FirebaseStorage.instance;
//   Reference ref = storage.ref().child('images/${DateTime.now().toString()}.png');
//   await ref.putFile(imageFile);
//   String imageUrl = await ref.getDownloadURL();
//   return imageUrl;
// }

  Future<void> sendMessFile(String receiverId, File imageFile) async {
  // Получение информации
  final String currentUserId = _auth.currentUser!.uid;
  final String currentUserEmail = _auth.currentUser!.email.toString();
  final Timestamp timestamp = Timestamp.now();

  // Загрузка изображения в Firebase Storage
  //final String imageUrl = await uploadImage(imageFile);
  final String imageUrl = "";

  // Создание сообщения с информацией о изображении
  final FileMes newMessage = FileMes(
    senderId: currentUserId,
    senderEmail: currentUserEmail,
    receiverId: receiverId,
    timestamp: timestamp,
    message: imageUrl,
  );

  // Создание идентификатора чатрума
  final List<String> ids = [currentUserId, receiverId];
  ids.sort();
  final String chatRoomId = ids.join("_");

  // Добавление в базу данных
  await _firestore
      .collection('chatrooms')
      .doc(chatRoomId)
      .collection('messages')
      .add(newMessage.toMap());
}

  // Get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherId) {
      final List<String> ids = [userId, otherId];
      ids.sort();
      print(ids);
      final String chatRoomId = ids.join("_");
      return _firestore
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false).snapshots();
    }
    
}
