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
