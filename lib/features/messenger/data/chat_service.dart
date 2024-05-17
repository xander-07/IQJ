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
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    final Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
      isEdited: false,
      messagePictures: List.empty(),
      messageFiles: List.empty(),
    );

    final List<String> ids = [currentUserId, receiverId];
    ids.sort();
    final String chatRoomId = ids.join("_");

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
    // File imageFile,
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

  bool isStringLink(String input) {
    Uri? uri = Uri.tryParse(input);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> getLinksFromChat(String userId, String otherId) async {
    final List<String> ids = [userId, otherId];
    ids.sort();
    final String chatroomId = ids.join("_");

    final querySnapshot = await _firestore
        .collection('direct_messages')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    final List<String> links = [];

    for (var doc in querySnapshot.docs) {
      final message = doc.data()['message'].toString();
      if (isStringLink(message)) {
        links.add(message);
      }
    }

    return links;
  }

  Future<String> getLastMessage(String userId, String otherId) async {
    final List<String> ids = [userId, otherId];
    ids.sort();
    final String chatroomId = ids.join("_");

    final querySnapshot = await _firestore
        .collection('direct_messages')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    final lastMessage = querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs.first.data()['senderEmail'].toString() +
            ": " +
            (!isStringLink(
                    querySnapshot.docs.first.data()['message'].toString())
                ? querySnapshot.docs.first.data()['message'].toString()
                : "[Ссылка]") +
            " • " +
            _formatTimestamp(
                querySnapshot.docs.first.data()['timestamp'] as Timestamp)
        : 'Нет сообщений';

    return lastMessage;
  }

  // Helper function, no requests made here. Move along, citizen.
  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final currentDate = DateTime.now();
    if (dateTime.year == currentDate.year &&
        dateTime.month == currentDate.month &&
        dateTime.day == currentDate.day) {
      return "Сегодня, ${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}";
    } else {
      return "${dateTime.day}.${dateTime.month}.${dateTime.year}, ${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}";
    }
  }

  // Thanks ChatGPT this sucks.
  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    }
    return "0$n";
  }

  Future<String> getUserEmail(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    final Map<String, dynamic> data = userDoc.data()! as Map<String, dynamic>;

    if (userDoc.exists) {
      return data['email'].toString();
    } else {
      return '';
    }
  }

  ////////////// ГРУППОВЫЕ СООБЩЕНИЯ ///////////////
  ///
  String generateRandomGroupId() {
    final Random random = Random();
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIKJLMNOPQRSTUVWXYZ0123456789-&*()^:;%#@!?/';
    return List.generate(32, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<String> createGroupChat(
      List<String> memberIds, String groupName) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String groupChatId = generateRandomGroupId();

    try {
      Map<String, dynamic> usersData = {
        currentUserId: {
          'joinDate': DateTime.now(),
          'email': _auth.currentUser!.email,
          'role': 'admin',
        },
      };

      for (String uid in memberIds) {
        String userEmail = await getUserEmail(uid);

        usersData[uid] = {
          'joinDate': DateTime.now(),
          'email': userEmail,
          'role': 'member',
        };
      }

      final Map<String, dynamic> chatData = {
        'users': usersData,
        'id': groupChatId,
        'name': groupName,
        'picture': 'none',
      };

      await _firestore.collection('groups').doc(groupChatId).set(chatData);
    } catch (e) {
      print("error creating group: $e");
    }

    return groupChatId;
  }

  Future<void> addUsersToGroupChat(
    List<String> memberIds,
    String groupChatId,
  ) async {
    print('adding users to group');
    try {
      // Iterate over memberIds to add users to the group
      for (String userId in memberIds) {
        // Retrieve user email from Firestore
        String userEmail = await getUserEmail(userId);

        // Add user to Firestore
        await _firestore.collection('groups').doc(groupChatId).update({
          'users.$userId': {
            'email': userEmail,
            'role': 'member',
            'joinDate': DateTime.now(),
          },
        });
      }
    } catch (e) {
      print('Error adding users: $e');
    }
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

  Future<String> getUserRoleInGroup(String groupId, String userId) async {
    print(userId);
    DocumentSnapshot groupSnapshot =
        await _firestore.collection('groups').doc(groupId).get();
    Map<String, dynamic>? usersData =
        groupSnapshot.data() as Map<String, dynamic>?;
    if (usersData!.containsKey('users')) {
      Map<String, dynamic>? usersMap =
          usersData['users'] as Map<String, dynamic>?;
      Map<String, dynamic>? userData =
          usersMap![userId] as Map<String, dynamic>?;
      String userRole = userData!['role'].toString();
      return userRole;
    }
    return 's';
  }

  Future<bool> isUserInGroup(String userId, String groupId) async {
    try {
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();
      Map<String, dynamic>? usersData =
          groupSnapshot.data() as Map<String, dynamic>?;
      if (usersData != null && usersData.containsKey('users')) {
        Map<String, dynamic>? usersMap =
            usersData['users'] as Map<String, dynamic>?;
        if (usersMap != null && usersMap.containsKey(userId)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error checking user in group: $e');
      return false;
    }
  }

  Future<void> setGroupName(String groupId, String name) async {
    await _firestore.collection('groups').doc(groupId).update({'name': name});
  }

  Future<void> sendMessageToGroup(String groupChatId, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    final GroupMessage newMessage = GroupMessage(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      timestamp: timestamp,
      message: message,
      // isReadBy: List.empty(),
      // isEdited: false,
      // messagePictures: List.empty(),
      // messageFiles: List.empty(),
    );

    await _firestore
        .collection('groups')
        .doc(groupChatId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
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
        ? querySnapshot.docs.first.data()['senderEmail'].toString() +
            ": " +
            querySnapshot.docs.first.data()['message'].toString() +
            " • " +
            _formatTimestamp(
                querySnapshot.docs.first.data()['timestamp'] as Timestamp)
        : 'Нет сообщений';

    return lastMessage;
  }

  Future<int> getNumberOfUsersInGroup(String groupId) async {
    DocumentSnapshot groupSnapshot =
        await _firestore.collection('groups').doc(groupId).get();
    Map<String, dynamic>? usersData =
        groupSnapshot.data() as Map<String, dynamic>?;

    if (!groupSnapshot.exists) {
      return 0;
    }

    Map<String, dynamic>? usersDataReal =
        usersData!['users'] as Map<String, dynamic>?;

    if (usersDataReal == null) {
      return 0;
    }

    return usersDataReal.length;
  }

  Future<List<Map<String, dynamic>>> getUsersInGroup(String groupId) async {
    try {
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();

      if (!groupSnapshot.exists) {
        return [];
      }

      Map<String, dynamic>? usersData =
          groupSnapshot.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> usersList = [];
      usersData['users'].forEach((key, value) {
        usersList.add({
          'uid': key,
          'email': value['email'],
          'role': value['role'],
          'joinDate': value['joinDate'],
        });
      });

      return usersList;
    } catch (e) {
      print("Error fetching users in group: $e");
      return [];
    }
  }

  Future groupGetImage(
    String receiverId,
    // File imageFile,
  ) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (imageFile != null) {
        fileUpload(receiverId, imageFile);
      }
    }
  }

  UploadTask groupUploadFile(File image, String filename) {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future groupFileUpload(
    //int typemesage,
    String groupId,
    File imageFile,
    //String chatId,
    //String preeId,
  ) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = groupUploadFile(imageFile, fileName);

    try {
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      sendMessageToGroup(groupId, imageUrl);
    } on FirebaseException catch (e) {
      sendMessageToGroup(groupId, e.toString());
      print("ошибочка в отпрвочке картиночик :( ");
    }
  }

  Future<List<String>> getLinksFromGroup(String id) async {

    final querySnapshot = await _firestore
        .collection('groups')
        .doc(id)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    final List<String> links = [];

    for (var doc in querySnapshot.docs) {
      final message = doc.data()['message'].toString();
      if (isStringLink(message)) {
        links.add(message);
      }
    }

    return links;
  }
}
