////////////////////////////////////////////////////////
///////////////////  Взято из KMess  ///////////////////
///////////////////     Доделать     ///////////////////
////////////////////////////////////////////////////////

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:iqj/features/messenger/domain/message.dart';

// import '../models/Response.dart';
// import '../models/chat.dart';

// class MessengerScreenViewModel extends ChangeNotifier {
//   List<Chat> chats = <Chat>[];
//   bool isChatsLoading = false;

//   late List<StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>> chatsStream = <StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>>[];
//   late List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> lMessageStream = <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>[];
//   late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> userStream;

//   Future<Response> getChats(BuildContext context) async {
//     try {
//       int errorChats = 0;

//       isChatsLoading = true;
//       FirebaseFirestore db = FirebaseFirestore.instance;
//       FirebaseAuth auth = FirebaseAuth.instance;

//       String? currentUserUID = auth.currentUser?.uid.toString();

//       chats.clear();

//       userStream = db.collection("Users").doc(currentUserUID).snapshots().listen((currentUser) async {
//         List<String> chatUIDs = List<String>.from(currentUser.get("ChatIDs"));

//         if (chatUIDs.isEmpty) {
//           isChatsLoading = false;
//           notifyListeners();
//         }

//         for (var chatUID in chatUIDs) {
//           chatsStream.add(db.collection("Chats").doc(chatUID).snapshots().listen((chat) async {
//               List<String> receiverUIDs = List<String>.from(chat.get("receiverUIDs"));
//               String receiverUID = "";

//               if (receiverUIDs.isNotEmpty) {
//                 receiverUID = receiverUIDs[0];
//               }

//               String chatName = chat.get("chat_name").toString();
//               String chatPicture = chat.get("chat_picture").toString();
//               bool isBlocked = false;
//               bool isVerified = chat.data()!.containsKey("isVerified") ? chat.get("isVerified") as bool : false;
//               bool isChatRoom = true;

//               bool userInChat = List.from(chat.get("receiverUIDs")).contains(currentUserUID) || chat.get("owner_uid") == currentUserUID;

//               if (chatName == "") {
//                 if (receiverUID == currentUserUID) {
//                   await db.collection("Users").doc(chat.get("owner_uid").toString()).get().then((usr) {
//                     chatName = "${usr.get("LastName")} ${usr.get("FirstName")}";
//                     chatPicture = usr.get("picture");
//                     isBlocked = usr.data()!.containsKey("Blocked") ? List.from(usr.get("Blocked")).contains(currentUserUID) : false || usr.data()!.containsKey("isDeleted") ? usr.get("isDeleted") : false;
//                     isVerified = usr.data()!.containsKey("isVerified") ? usr.get("isVerified") as bool : false;
//                   });
//                 }
//                 else {
//                   try {
//                     await db.collection("Users").doc(receiverUID).get().then((usr) {
//                       String lastName = usr.data()!.containsKey("surname") ? usr.get("surname") : "";
//                       String firstName = usr.data()!.containsKey("name") ? usr.get("name") : "";
//                       chatName = "$lastName $firstName";
//                       chatPicture = usr.get("picture");
//                       isBlocked = usr.data()!.containsKey("blocked") ? List.from(usr.get("blocked")).contains(currentUserUID) : false || usr.data()!.containsKey("isDeleted") ? usr.get("isDeleted") : false;
//                       isVerified = usr.data()!.containsKey("isVerified") ? usr.get("isVerified") as bool : false;
//                     });
//                   } catch (e) {
//                     if (kDebugMode) {
//                       print(e);
//                     }
//                   }
//                 }

//                 isChatRoom = false;

//                 notifyListeners();
//               }

//               Message? chatLastMessage;

//               if (userInChat) {
//                 lMessageStream.add(db.collection("Groups").doc(chat.id).collection("Messages").orderBy("timestamp", descending: true).limit(10).snapshots().listen((lastMessage) async {
//                   if (lastMessage.docs.isNotEmpty) {
//                     var unreadCount = 0;
//                     for (var message in lastMessage.docs) {
//                       List<String> readBy = message.data().containsKey("isReadBy") ? List<String>.from(message.get("isReadBy")) : List<String>.empty();
//                       if (!readBy.contains(currentUserUID) && message.get("sender") != currentUserUID) {
//                         unreadCount += 1;
//                       }
//                     }
                      
//                     String senderUID = lastMessage.docs.first.get("senderId").toString();
//                     String senderName = "";

//                     if (currentUserUID != senderUID) {
//                       await db.collection("Users").doc(senderUID).get().then((sender) {
//                         senderName = sender.get("email");
//                       });
//                     }
//                     else {
//                       senderName = "Вы";
//                     }

//                     String messageText = "$senderName: ${lastMessage.docs.first.get("message_text").toString()}";

//                     chatLastMessage = Message(
//                         // messageUID: lastMessage.docs.first.id,
//                         message: messageText,
//                         isEdited: lastMessage.docs.first.data().containsKey("isEdited") ? lastMessage.docs.first.get("isEdited") : false,
//                         senderId: lastMessage.docs.first.get("sender").toString(),
//                         senderEmail: senderName,
//                         timestamp: lastMessage.docs.first.get("timestamp") as Timestamp,
//                         messagePictures: List<String>.from(lastMessage.docs.first.get("message_pictures")),
//                         messageFiles: List<String>.from(lastMessage.docs.first.get("message_files"))
//                     );

//                     _addNewChat(Chat(
//                       chatUID: chat.id,
//                       chatOwnerUID: chat.get("owner_uid").toString(),
//                       chatReceiverUIDs: List<String>.from(chat.get("receiverUIDs")),
//                       chatName: chatName,
//                       chatPicture: chatPicture,
//                       usersInChat: List<String>.from(chat.get("inChat")),
//                       chatNotificationsDisabled: List<String>.from(chat.get("notifications_disabled")),
//                       isChatRoom: isChatRoom,
//                       chatLastMessage: chatLastMessage,
//                       isVerified: isVerified,
//                       isBlocked: isBlocked,
//                       unreadCount: unreadCount
//                     ));

//                     if (chats.length == chatUIDs.length) {
//                       isChatsLoading = false;
//                     } else {
//                       isChatsLoading = true;
//                     }

//                     notifyListeners();
//                   }
//                   else {
//                     _addNewChat(Chat(
//                         chatUID: chat.id,
//                         chatOwnerUID: chat.get("owner_uid").toString(),
//                         chatReceiverUIDs: List<String>.from(chat.get("receiverUIDs")),
//                         chatName: chatName,
//                         chatPicture: chatPicture,
//                         usersInChat: List<String>.from(chat.get("inChat")),
//                         chatNotificationsDisabled: List<String>.from(chat.get("notifications_disabled")),
//                         isChatRoom: isChatRoom,
//                         chatLastMessage: chatLastMessage,
//                         isVerified: isVerified,
//                         isBlocked: isBlocked
//                     ));

//                     if (chats.length - errorChats == chatUIDs.length) {
//                       isChatsLoading = false;
//                     } else {
//                       isChatsLoading = true;
//                     }

//                     notifyListeners();
//                   }
//                 }, onError: (e) {
//                   for (var l in lMessageStream) {
//                     l.cancel();
//                   }

//                   for (var c in chatsStream) {
//                     c.cancel();
//                   }

//                   getChats(context);
//                 }));
//               } else {
//                 errorChats += 1;

//                 if (chats.length - errorChats == chatUIDs.length) {
//                   isChatsLoading = false;
//                 } else {
//                   isChatsLoading = true;
//                 }

//                 notifyListeners();
//               }
//           }));
//         }
//       });

//       return Response(isSuccess: true, message: "Success", code: 0);
//     }
//     catch (e) {
//       return Response(isSuccess: false, message: e.toString(), code: -1);
//     }
//   }

//   void _addNewChat(Chat chat) {
//     if (chats.any((element) => element.chatUID == chat.chatUID)) {
//       for (var c in chats) {
//         if (c.chatUID == chat.chatUID) {
//           c.chatLastMessage = chat.chatLastMessage;
//           c.chatNotificationsDisabled = chat.chatNotificationsDisabled;
//           c.chatPicture = chat.chatPicture;
//           c.chatName = chat.chatName;
//           c.unreadCount = chat.unreadCount;
//           break;
//         }
//       }

//         chats.sort((a, b) {
//           try {
//             return b.chatLastMessage!.timestamp.compareTo(a.chatLastMessage!.timestamp);
//           } catch (e) {
//             return Timestamp(1, 1).compareTo(Timestamp(2, 1));
//           }
//         });
//     } else {
//       chats.add(chat);

//         chats.sort((a, b) {
//           try {
//             return b.chatLastMessage!.timestamp.compareTo(a.chatLastMessage!.timestamp);
//           } catch (e) {
//             return Timestamp(1, 1).compareTo(Timestamp(2, 1));
//           }
//         });
//     }
//   }

//   void clear() {
//     chats.clear();

//     try {
//       for (var l in lMessageStream) {
//         l.cancel();
//       }
//       for (var c in chatsStream) {
//         c.cancel();
//       }
//       chatsStream.clear();
//       lMessageStream.clear();
//       userStream.cancel();
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
// }
