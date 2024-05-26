import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iqj/features/messenger/data/chat_service.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  Color boxFillColor = const Color(0xFFF6F6F6);
  bool isError = false;
  ChatService chatService = ChatService();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      //alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0),
        child: Container(
          padding: EdgeInsets.all(1), // Border width
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1.0, color: Color(0xFFEFAC00)),
          ),
          child: ClipOval(
            child: FutureBuilder<String>(
              future: chatService.getProfilePicture(auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Icon(Icons.account_circle, size: 72);
                } else {
                  return SizedBox.fromSize(
                    size: Size.fromRadius(72), // Image radius
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
