import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iqj/features/messenger/domain/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ////////////// Личные сообщения ///////////////
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
        .collection('direct_messages')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Future<void> sendMessFile(String receiverId, File message) async {
    // get info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create msg
    // final Message newMessage = Message(
    //   senderId: currentUserId,
    //   senderEmail: currentUserEmail,
    //   receiverId: receiverId,
    //   timestamp: timestamp,
    //   message: message,
    // );
    final FileMes newFile = FileMes(
        senderId: currentUserId,
        senderEmail: currentUserId,
        receiverId: receiverId,
        message: message, // ???
        timestamp: timestamp);

    // make chatroom
    final List<String> ids = [currentUserId, receiverId];
    ids.sort();
    print(ids);
    final String chatRoomId = ids.join("_");

    // add to db
    await _firestore
        .collection('direct_messages')
        .doc(chatRoomId)
        .collection('messages')
        .add(newFile.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherId) {
    final List<String> ids = [userId, otherId];
    ids.sort();
    print(ids);
    final String chatRoomId = ids.join("_");
    return _firestore
        .collection('direct_messages')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }



  ////////////// ГРУППОВЫЕ ///////////////
  // Generate random group chat ID
  String generateRandomGroupId() {
    final Random random = Random();
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(10, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

// Create group chat with a random ID
  Future<void> createGroupChat(List<String> memberIds) async {
    // Get info
    final String currentUserId = _auth.currentUser!.uid;

    // Generate random chatroom id
    final String groupChatId = generateRandomGroupId();
    print(groupChatId);

    // Add users to the group chat
    final Map<String, bool> users = {};
    for (String uid in memberIds) {
      users[uid] = true;
    }

    print('creating group');
    // Add users to Firestore
    await _firestore
        .collection('groups')
        .doc(groupChatId)
        .collection('users')
        .add(users);
  }

  Future<void> addUserToGroupChat(String groupChatId, String userId) async {
    print('adding user to group');
    // Add user to Firestore
    await _firestore
        .collection('groups')
        .doc(groupChatId)
        .collection('users')
        .doc('users')
        .update({
      userId: true,
    });
  }

  Future<void> sendMessageToGroup(String groupChatId, String message) async {
    // get info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create msg
    final GroupMessage newMessage = GroupMessage(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      timestamp: timestamp,
      message: message,
    );

    // add to db
    await _firestore
        .collection('group')
        .doc(groupChatId)
        .collection('messages')
        .add(newMessage.toMap());
  }
}
