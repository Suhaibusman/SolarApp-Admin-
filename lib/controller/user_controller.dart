import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';

class UserController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List productname = ["Monocrystalline", "Polycrystalline", "Thin-film"];

  List productImages = [
    ImageConstants.monocrystalineImage,
    ImageConstants.polycrystallineImage,
    ImageConstants.thinFilmImage
  ];

  List productDescription = [
    "Of all the solar panel types, monocrystalline panels are likely to be the most expensive option. This is largely due to the manufacturing process.",
    "Polycrystalline solar panels are typically cheaper than monocrystalline solar panels.",
    "What you pay for thin-film solar cells will largely depend on the type of thin-film panel."
  ];

  List productTitle = [
    "High efficiency and performance",
    "Lower costs",
    "Portable and flexible"
  ];

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
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      imagePath == ""
                          ? "https://www.plslwd.org/wp-content/plugins/lightbox/images/No-image-found.jpg"
                          : imagePath,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(doc["username"] ?? "No Name"),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(doc["phoneNumber"] ?? "No Phone Number"),
                    ],
                  ),
                  subtitle: Text(doc["emailAddress"] ?? "No Email"),
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
