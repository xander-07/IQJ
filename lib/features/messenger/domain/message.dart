import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  bool isEdited;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final List<String> messagePictures;
  final List<String> messageFiles;
  List<String>? isReadBy;

  Message(
      {required this.senderId,
      required this.senderEmail,
      required this.isEdited,
      required this.receiverId,
      required this.message,
      required this.timestamp,
      required this.messagePictures,
      required this.messageFiles,
      this.isReadBy
      }
  );

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'isEdited': isEdited,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'pictures': messagePictures,
      'files': messageFiles,
      'readBy': isReadBy,
    };
  }
}

class GroupMessage {
  final String senderId;
  final String senderEmail;
  //bool isEdited;
  final String message;
  final Timestamp timestamp;
  // final List<String> messagePictures;
  // final List<String> messageFiles;
  // List<String>? isReadBy;

  GroupMessage(
    {required this.senderId,
      required this.senderEmail,
      //required this.isEdited,
      required this.message,
      required this.timestamp,
      // required this.messagePictures,
      // required this.messageFiles,
      // this.isReadBy
    }
  );

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      //'isEdited': isEdited,
      'message': message,
      'timestamp': timestamp,
      // 'pictures': messagePictures,
      // 'files': messageFiles,
      // 'readBy': isReadBy,
    };
  }
}

class FileMes {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final File message;
  final Timestamp timestamp;

  FileMes({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
