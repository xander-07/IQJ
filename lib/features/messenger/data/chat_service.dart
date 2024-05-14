import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iqj/features/messenger/domain/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ////////////// ЛИЧНЫЕ СООБЩЕНИЯ ///////////////
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
  //     message: message, // ???
  //     timestamp: timestamp,
  //   );

  //   // make chatroom
  //   final List<String> ids = [currentUserId, receiverId];
  //   ids.sort();
  //   print(ids);
  //   final String chatRoomId = ids.join("_");

  //   // add to db
  //   await _firestore
  //       .collection('direct_messages')
  //       .doc(chatRoomId)
  //       .collection('messages')
  //       .add(newFile.toMap());
  // }

  Future getImage(
    String receiverId,
    File imageFile,
  ) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFIle;

    pickedFIle = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFIle != null) {
      File imageFile = File(pickedFIle.path);
      if (imageFile != null) {
        fileUpload(receiverId, imageFile);
      }
    }
  }

  UploadTask uploadFile(File image, String filename) {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future fileUpload(
    //int typemesage,
    String receiverId,
    File imageFile,
    //String chatId,
    //String preeId,
  ) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = uploadFile(imageFile, fileName);

    try {
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      sendMessage(receiverId, imageUrl);
    } on FirebaseException catch (e) {
      sendMessage(receiverId, e.toString());
      print("ошибочка в отпрвочке картиночик :( ");
    }
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

  Future<String> getProfilePicture(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(userId).get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();
      String profilePictureUrl = data!['picture'] as String;

      return profilePictureUrl;
    } else {
      return '';
    }
  }

  Future<String> getLastMessage(String userId, String otherId) async {
    final List<String> ids = [userId, otherId];
    ids.sort();
    print(ids);
    final String chatroomId = ids.join("_");

    final querySnapshot = await _firestore
        .collection('direct_messages')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    final lastMessage = querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs.first.data()['message'].toString()
        : 'Нет сообщений';

    return lastMessage;
  }

  ////////////// ГРУППОВЫЕ СООБЩЕНИЯ ///////////////
  // Generate random group chat ID
  String generateRandomGroupId() {
    final Random random = Random();
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIKJLMNOPQRSTUVWXYZ0123456789-&*()^:;%#@!?/';
    return List.generate(32, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

// Create group chat with a random ID
  Future<String> createGroupChat(
      List<String> memberIds, String groupName) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String groupChatId = generateRandomGroupId();

    // Initialize group chat data
    final Map<String, dynamic> chatData = {
      'users': {
        currentUserId: {
          'joinDate': DateTime.now(),
          'email': _auth.currentUser!.email,
          'role': 'admin',
        },
        for (final memberId in memberIds)
          memberId: {
            'joinDate': DateTime.now(),
            'email': 'test@temporary.xd',
            'role': 'member',
          },
      },
      'id': groupChatId,
      'name': groupName,
      'picture': 'none',
    };

    await _firestore.collection('groups').doc(groupChatId).set(chatData);

    return groupChatId;
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

  Future<void> removeUserFromGroup(String groupId, String userId) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .update({'users.$userId': FieldValue.delete()});
  }

  Future<void> assignUserRoleInGroup(
      String groupId, String userId, Map<String, dynamic> newData) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .update({'users.$userId': newData});
  }

  Future<void> setGroupName(String groupId, String name) async {
    // Надо тестить
    await _firestore.collection('groups').doc(groupId).update({'name': name});
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
        .collection('groups')
        .doc(groupChatId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getGroupMessages(String id) {
    return _firestore
        .collection('groups')
        .doc(id)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<String> getLastGroupMessage(String groupId) async {
    final querySnapshot = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    final lastMessage = querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs.first.data()['message'].toString()
        : 'Нет сообщений';

    return lastMessage;
  }
}
