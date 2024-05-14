import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:iqj/features/messenger/data/chat_service.dart';
//import 'package:flutter_reversed_list/flutter_reversed_list.dart';
import 'package:iqj/features/messenger/presentation/screens/date_for_load_chats.dart';
import 'package:iqj/features/messenger/presentation/screens/file_chat.dart/file_chat.dart';
import 'package:iqj/features/messenger/presentation/screens/struct_of_message.dart';
import 'package:flutter/foundation.dart' as foundation;
//import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
//import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:image_picker/image_picker.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});
  @override
  State<StatefulWidget> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  Widget _buildThumbnailImage(String image_url) {
    try {
      return Container(
        padding: EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 45,
          height: 45,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.network(
              image_url,
              fit: BoxFit.fill,
              height: 200,
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) {
                return CircleAvatar(
                  radius: 6,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: const Text('A'),
                );
              },
            ),
          ),
        ),
      );
    } catch (e) {
      return Container();
    }
  }

  String? user_name = "..."; // Объявление user_name как поле класса
  String? image_url = "";
  String uid = "";
  bool vol = false;
  bool pin = false;
  bool _emojiPicking = false;
  File? imageFile;

  selectFileImage() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1800,
      maxWidth: 1800,
    );

    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
    }
  }

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        File imageFile = File(result.files.single.path!);
      });
      
    } else {
      // User canceled the picker
    }
  }

  Future uploadImage() async {}

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null, "Check args");
    Map<String, dynamic> help = args as Map<String, dynamic>;
    user_name =
        help["name"] as String?; // Присваивание значения переменной user_name
    image_url = help["url"] as String?;
    vol = help["volume"] as bool;
    pin = help["pin"] as bool;
    uid = help["uid"] as String;

    setState(() {});
    super.didChangeDependencies();
  }

  final TextEditingController _msgController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DateTime? currentDate;
  ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_msgController.text.isNotEmpty) {
      await _chatService.sendMessage(
        uid,
        _msgController.text,
      );
      _msgController.clear();
    }
    // if (imageFile != null && imageFile!.existsSync()) {
    //   await _chatService.getImage(uid, imageFile!);
    // }
    if (imageFile != null && imageFile!.existsSync()) {
       await _chatService.fileUpload(uid,imageFile!); 
    }
  }

  void emojiPickerSet() {
    setState(() {
      _emojiPicking = !_emojiPicking;
    });
  }

  bool file_check = false;

  void checkFIle(){
    setState(() {
      file_check = !file_check;
    });
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        uid,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Widget> messageWidgets = [];
        for (int i = 0; i < snapshot.data!.docs.length; i++) {
          final document = snapshot.data!.docs[i];
          final Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
          final messageDate = (data['timestamp'] as Timestamp).toDate();

          if (currentDate == null || messageDate.day != currentDate!.day) {
            messageWidgets.add(_buildDateWidget(messageDate));
            currentDate = messageDate;
          }

          messageWidgets.add(_buildMessageListItem(document));
        }

        return Align(
          alignment: Alignment.bottomCenter,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 8),
            physics: ClampingScrollPhysics(),
            //reverse: true,
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: messageWidgets.length,
            itemBuilder: (context, index) {
              return messageWidgets[index];
            },
          ),
        );
      },
    );
  }

  Widget _buildDateWidget(DateTime date) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            DateFormat('dd MMM, yyyy').format(date),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageListItem(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    print(data);
    final mainalignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? MainAxisAlignment.start
        : MainAxisAlignment.end;
    final alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12),
      alignment: alignment,
      child: ReceiverMessage(
        message: data['message'].toString(),
        //mainAxisAlignment: mainalignment,
        url: image_url!,
        receiver: data['senderId'] as String,
        compare: _firebaseAuth.currentUser!.uid,
        time: DateFormat('HH:mm')
            .format((data['timestamp'] as Timestamp).toDate()), 
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget getFileWidget(File file) {
    String extension = file.path.split('.').last.toLowerCase();
    if (extension == 'jpg' ||
        extension == 'jpeg' ||
        extension == 'png' ||
        extension == 'gif') {
      print('image');
      return Image.file(
        file,
        fit: BoxFit.contain,
      );
    } else if (extension == 'mp3' || extension == 'wav' || extension == 'aac') {
      print('audio');
      return AudioWidget(file: file);
      // } else if (extension == 'pdf') {
      //   return PDFImage(
      //     file: File(file.path),
      //     width: 200, // задайте желаемую ширину изображения
      //     height: 200, // задайте желаемую высоту изображения
      //     fitPolicy: FitPolicy.WIDTH_AND_HEIGHT, // опционально, чтобы сохранить соотношение сторон и заполнить всю область изображения
      //   )
    } else if (extension == 'mp4' || extension == 'mkv' || extension == 'avi') {
      print('video');
      return VideoWidget(file: file);
    } else {
      return Text('Неподдерживаемый тип файла');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              surfaceTintColor:
                  const MaterialStatePropertyAll(Colors.transparent),
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.background,
              ),
              shadowColor: const MaterialStatePropertyAll(Colors.transparent),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            onPressed: () {
              // Потом сделать страницу пользователя

            },
            child: Row(
              children: [
                _buildThumbnailImage(image_url ?? ""),
                //const Padding(padding: EdgeInsets.only(right: 12)),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Text(
                              user_name ?? "",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontSize: 20,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          vol ? Icon(Icons.volume_off) : Container(),
                          pin ? Icon(Icons.push_pin_outlined) : Container(),
                        ],
                      ),
                      Text(
                        "был в сети недавно",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    // Действие при нажатии на кнопку с телефоном
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    // Действие при нажатии на кнопку
                  },
                ),
                // PopupMenuButton<String>(
                //   onSelected: (String choice) {},
                //   itemBuilder: (BuildContext context) {
                //     return {'Настройки', 'Статус'}.map((String choice) {
                //       return choice == "Настройки"
                //           ? PopupMenuItem<String>(
                //               value: choice,
                //               child: Row(
                //                 children: [
                //                   const Icon(Icons.settings_outlined),
                //                   const Padding(
                //                     padding: EdgeInsets.only(right: 12),
                //                   ),
                //                   Text(choice),
                //                 ],
                //               ),
                //             )
                //           : PopupMenuItem<String>(
                //               value: choice,
                //               child: Row(
                //                 children: [
                //                   const Icon(
                //                     Icons.tag_faces_sharp,
                //                   ),
                //                   const Padding(
                //                     padding: EdgeInsets.only(right: 12),
                //                   ),
                //                   Text(choice),
                //                 ],
                //               ),
                //             );
                //     }).toList();
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              //height: 72,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onInverseSurface,
                border: Border.all(width: 0, color: Colors.transparent),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(6),
              child: Column(
                children: [
                  (imageFile != null && imageFile!.existsSync() && file_check)
                      ? Container(
                          //height: 100,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).backgroundColor,
                          // child: Image.file(
                          //   imageFile!,
                          //   fit: BoxFit.fitWidth,
                          // ),
                          child: getFileWidget(imageFile!),
                        )
                      : Container(),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          //emojiPickerSet();
                          //FocusManager.instance.primaryFocus?.unfocus();
                        },
                        icon: Icon(Icons.insert_emoticon),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _msgController,
                          decoration: InputDecoration(
                            filled: true, // Включаем заливку цветом
                            fillColor:
                                Theme.of(context).colorScheme.onInverseSurface,
                            hintText: "Введите сообщение...",
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          selectFileImage();
                          checkFIle();
                          //await _chatService.fileUpload(uid,imageFile!);      
                        },
                        icon: Icon(Icons.attach_file_outlined),
                      ),
                      IconButton(
                        onPressed: () async {
                          // var imageName = DateTime.now().millisecondsSinceEpoch.toString(); 
                          //        var storageRef = FirebaseStorage.instance.ref().child('driver_images/$imageName.jpg'); 
                          //        var uploadTask = storageRef.putFile(_image!); 
                          //        var downloadUrl = await (await uploadTask).ref.getDownloadURL(); 
  
                          //        firestore.collection("Driver Details").add({ 
                          //          "Name": nameController.text, 
                          //          "Age": ageController.text, 
                          //          "Driving Licence": dlController.text, 
                          //          "Address.": adController.text, 
                          //          "Phone No.": phnController.text, 
                          //          // Add image reference to document 
                          //          "Image": downloadUrl.toString()  
                          //        }); 
                          sendMessage();
                          checkFIle();
                        },
                        icon: Icon(Icons.send),
                      ),
                    ],
                  ),
                  // if (_emojiPicking) Padding(padding: EdgeInsets.only(bottom: 6)),
                  // if (_emojiPicking) EmojiPicker(
                  //     textEditingController: _msgController,
                  //     //scrollController: _scrollController,
                  //     config: Config(
                  //       //height: 256,
                  //       checkPlatformCompatibility: true,
                  //       emojiViewConfig: EmojiViewConfig(
                  //         emojiSizeMax: 28 *
                  //             (foundation.defaultTargetPlatform ==
                  //                     TargetPlatform.iOS
                  //                 ? 1.2
                  //                 : 1.0),
                  //       ),
                  //       swapCategoryAndBottomBar: false,
                  //       skinToneConfig: const SkinToneConfig(),
                  //       categoryViewConfig: const CategoryViewConfig(),
                  //       bottomActionBarConfig: const BottomActionBarConfig(),
                  //       searchViewConfig: const SearchViewConfig(),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
