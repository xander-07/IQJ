import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iqj/features/messenger/data/chat_service.dart';
import 'package:iqj/features/messenger/presentation/chat_bubble.dart';
import 'package:iqj/features/messenger/presentation/group_bubble.dart';

class ChatManager extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<QuerySnapshot>? _snapshots;

  bool flag1 = false;
  bool flag2 = false;
  bool flag3 = false;
  bool flag4 = false;
  bool flag5 = false;
  bool flag6 = false;

  bool loading = true;

  Future<void> fetchChatData() async {
    try {
      _snapshots = await Future.wait([
        _firestore.collection('users').get(),
        _firestore.collection('groups').get(),
      ]);
      flag1 = true; // Set flags accordingly based on your logic
      flag2 = true;
      flag3 = true;
      flag4 = true;
      flag5 = true;
      flag6 = true;
      notifyListeners();
    } catch (e) {
      print('Error fetching chat data: $e');
    }
  }

  List<Widget> buildChatList() {
    List<Widget> chatList = [];

    // Load direct messages
    if (flag1 || flag3 || flag4 || flag5 || flag6) {
      chatList.addAll(
          _snapshots![0].docs.map<Widget>((doc) => _buildChatListItem(doc)));
    }

    // Load group chats using getLastGroupMessage function
    if (flag1 || flag2 || flag6) {
      _snapshots![1].docs.forEach((groupDoc) {
        final Map<String, dynamic> groupData =
            groupDoc.data() as Map<String, dynamic>;
        String groupId = groupDoc.id;
        String groupName = groupData['name'].toString();

        chatList.add(
          FutureBuilder<String>(
            future: _chatService.getLastGroupMessage(groupId),
            initialData: 'Loading...',
            builder: (context, AsyncSnapshot<String> messageSnapshot) {
              String lastMessage = messageSnapshot.data ?? '';

              if (messageSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (messageSnapshot.hasError) {
                return Text('Error fetching last message');
              }

              return GroupBubble(
                imageUrl: '',
                chatTitle: groupName,
                secondary: lastMessage,
                id: groupId,
              );
            },
          ),
        );
      });
    }
    loading = false;
    return chatList;
  }

  Widget _buildChatListItem(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final ChatService _chatService = ChatService();

    return FutureBuilder<String>(
      future: _chatService.getLastMessage(
          _auth.currentUser!.uid, data['uid'].toString()),
      initialData: 'Loading...', // Initial value while waiting for the future
      builder: (context, AsyncSnapshot<String> snapshot) {
        String lastMessage = snapshot.data ?? '';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // You can return another loading indicator here
        } else if (snapshot.hasError) {
          return Text('Error fetching last message');
        }

        if (_auth.currentUser!.email != data['email']) {
          return ChatBubble(
            imageUrl: data['picture'].toString(),
            chatTitle: data['email'].toString(),
            secondary: lastMessage,
            uid: data['uid'].toString(),
            phone: data['phone'].toString(),
          );
        }

        return ChatBubble(
          imageUrl: data['picture'].toString(),
          chatTitle: 'Заметки',
          secondary: lastMessage,
          uid: data['uid'].toString(),
          phone: data['phone'].toString(),
        );
      },
    );
  }
}
