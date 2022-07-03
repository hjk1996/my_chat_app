import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformation with ChangeNotifier {
  String? eMail;
  String? username;
  String? profileUrl;

  Future<void> fetchUserInfo(String uid) async {
    final userSnapshpt =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userInfo = userSnapshpt.data();

    eMail = userInfo!['e-mail'];
    username = userInfo['username'];
    profileUrl = userInfo['profile_image_url'];
  }
}
