import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_admin/utils/constants/image_constant.dart';
import 'package:solar_admin/utils/themes/color_theme.dart';
import 'package:solar_admin/utils/widgets/text_widget.dart';

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
                      ctext(
                          text: doc["username"] ?? "No Name",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: btnPrimaryColor),
                      const SizedBox(
                        width: 10,
                      ),
                      ctext(
                          text: doc["phoneNumber"] ?? "No Phone Number",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ],
                  ),
                  subtitle: ctext(
                      text: doc["emailAddress"] ?? "No Email",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
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
