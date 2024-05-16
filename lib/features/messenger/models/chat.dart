import 'package:iqj/features/messenger/domain/message.dart';

class Chat {
  final String chatUID;
  final String chatOwnerUID;
  final List<String> chatReceiverUIDs;
  String chatName;
  String chatPicture;
  final List<String> usersInChat;
  List<String> chatNotificationsDisabled;
  final bool isChatRoom;
  Message? chatLastMessage;
  final bool? isVerified;
  final bool isBlocked;
  int unreadCount;

  Chat({
    required this.chatUID,
    required this.chatOwnerUID,
    required this.chatReceiverUIDs,
    required this.chatName,
    required this.chatPicture,
    required this.usersInChat,
    required this.chatNotificationsDisabled,
    required this.isChatRoom,
    this.chatLastMessage,
    this.isVerified,
    required this.isBlocked,
    this.unreadCount = 0
  });
}