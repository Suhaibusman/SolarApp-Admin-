import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:solar_admin/controller/chat_controller.dart';

import 'package:solar_admin/utils/constants/app_constant.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/utils/widgets/helper_widget.dart';
import 'package:solar_admin/utils/widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  final String uid;
  final String username;
  final String image;

  ChatScreen(
      {super.key,
      required this.uid,
      required this.username,
      required this.image});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .collection(widget.username)
        .orderBy('currenttime')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      chatController.messages.assignAll(snapshot.docs.map((doc) {
        return {
          'message': doc['message'] ?? '',
          'isSent': doc['isSent'] ?? false,
          'currenttime': doc['currenttime'] ?? '',
        };
      }).toList());
    });
  }

  final ChatController chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: ctext(
            text: 'Chat',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: white),
        leading: reusableBackButton(),
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            SvgConstants.homeBg,
            width: Get.width,
            fit: BoxFit.fill,
          ),
          SizedBox(
            width: double.maxFinite,
            height: Get.height,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Lottie.asset(ImageConstants.bot,
                        height: Get.height * 0.2)),
                smallSpace,
                Expanded(
                  child: Obx(() => // Inside your ListView.builder
                      ListView.builder(
                        itemCount: chatController.messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final message =
                              chatController.messages[index]['message'];
                          final isSent =
                              chatController.messages[index]['isSent'];
                          final currentTime =
                              chatController.messages[index]['currenttime'];

                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: isSent == false
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipPath(
                                            clipper: LowerNipMessageClipper(
                                                MessageType.send),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: lightPrimaryTextColor,
                                              ),
                                              constraints: BoxConstraints(
                                                maxWidth: Get.width *
                                                    0.6, // Set the maximum width here
                                              ),
                                              child: Text(
                                                message.toString(),
                                                maxLines: 6,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          ctext(
                                            text: currentTime.toString(),
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                      mediumSpaceh,
                                      const CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          "https://img.freepik.com/free-photo/woman-with-long-hair-yellow-hoodie-with-word-music-it_1340-39068.jpg?size=626&ext=jpg&ga=GA1.1.117946456.1673173317&semt=sph",
                                        ),
                                      ).paddingOnly(top: 15),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          widget.image,
                                        ),
                                      ).paddingOnly(bottom: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipPath(
                                            clipper: LowerNipMessageClipper(
                                                MessageType.receive),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: lightPrimaryTextColor,
                                              ),
                                              constraints: BoxConstraints(
                                                maxWidth: Get.width *
                                                    0.6, // Set the maximum width here
                                              ),
                                              child: Text(
                                                message.toString(),
                                                maxLines: 6,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          ctext(
                                            text: currentTime.toString(),
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          );
                        },
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: white.withOpacity(.7),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextField(
                            controller: chatController.msgController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: primarycolor.withOpacity(.3),
                              hintText: 'Type Something',
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          chatController.handleUserInput(
                              currentid: widget.uid,
                              currentName: widget.username);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: white.withOpacity(.7),
                          ),
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.send,
                            color: btnPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
