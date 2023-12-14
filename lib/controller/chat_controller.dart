import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solar_admin/view/nav_bar/chat_view/chat_view.dart';

class ChatController extends GetxController {
  TextEditingController msgController = TextEditingController();
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> selectedUserData = <String, dynamic>{}.obs;
  String formattedTime = "";
  RxBool isOptionButtonVisible = true.obs;
  bool chatActive = true;
  bool isEnterAddress = false;
  final greetings = ["hi", "hello", "hey"];

  String currentUid = "";
  String currentUsername = "";
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // @override
  // void onInit() {
  //   super.onInit();

  // firestore
  //     .collection("users")
  //     .doc(selectedUserData['uid'])
  //     .collection(selectedUserData['username'])
  //     .orderBy('currenttime')
  //     .snapshots()
  //     .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
  //   messages.assignAll(snapshot.docs.map((doc) {
  //     return {
  //       'message': doc['message'] ?? '',
  //       'isSent': doc['isSent'] ?? false,
  //       'currenttime': doc['currenttime'] ?? '',
  //     };
  //   }).toList());
  // });
  // }

  String getCurrentTime() {
    final DateTime now = DateTime.now();
    final String formattedTime =
        DateFormat('h:mm:ss a').format(now); // Format for "10:14 PM"

    return formattedTime;
  }

  Future<void> sendMessage(
      {message, required String currentid, required String currentName}) async {
    await firestore
        .collection("users")
        .doc(currentid)
        .collection(currentName) // Create a sub-collection for messages
        .add({
      'message': message,
      'isSent': false,
      'currenttime': getCurrentTime(),
    });
  }

  Future<void> handleUserInput(
      {required String currentid, required String currentName}) async {
    if (msgController.text.isEmpty) {
      Get.snackbar("Undefined", "Please enter your complaint");
    } else {
      await sendMessage(
          message: msgController.text,
          currentName: currentName,
          currentid: currentid);
      msgController.clear();
    }
  }

  Future<List<DocumentSnapshot>> getChats({
    required String name,
    required String uid,
  }) async {
    CollectionReference userChats =
        firestore.collection("users").doc(uid).collection(name);
    QuerySnapshot userChatSnapshot = await userChats.get();

    if (userChatSnapshot.docs.isNotEmpty) {
      // print(userChatSnapshot.docs);
      return userChatSnapshot.docs;
    }
    // print("No chats found");
    return [];
  }

  Future<Widget> fetchWholeData() async {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                //querysnaphot me pora data ayegaa
                String imagePath = doc["profileImage"];
                return InkWell(
                  onTap: () {
                    selectedUserData.assignAll({
                      'uid': doc["uid"],
                      'username': doc["username"],
                    });
                    Get.to(() => ChatScreen(
                          uid: doc["uid"],
                          username: doc["username"],
                          image: imagePath == ""
                              ? "https://www.plslwd.org/wp-content/plugins/lightbox/images/No-image-found.jpg"
                              : doc["profileImage"],
                        ));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        imagePath == ""
                            ? "https://www.plslwd.org/wp-content/plugins/lightbox/images/No-image-found.jpg"
                            : imagePath,
                      ),
                    ),
                    title: Text(doc["username"]),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No Data Found"));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
