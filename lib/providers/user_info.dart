import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformation with ChangeNotifier {
  String? _eMail;
  String? _username;
  String? _profileUrl;
  List<dynamic>? _userChatList;

  String? get eMail {
    return _eMail;
  }

  void setEmail(String eMail) {
    _eMail = eMail;
  }

  String? get username {
    return _username;
  }

  void setUsername(String username) {
    _username = username;
  }

  String? get profileUrl {
    return _profileUrl;
  }

  void setProfileUrl(String profileUrl) {
    _profileUrl = profileUrl;
  }

  List<dynamic>? get userChatList {
    return _userChatList;
  }

  void addNewChat(String chatRoomId) {
    _userChatList ??= [];
    _userChatList!.add(chatRoomId);
    notifyListeners();
  }

  Future<void> fetchUserInfo(String uid) async {
    late Map<String, dynamic>? userInfo;

    while (true) {
      final userSnapshot = await Future.delayed(
        Duration(seconds: 1),
        () {
          return FirebaseFirestore.instance.collection('users').doc(uid).get();
        },
      );
      userInfo = userSnapshot.data();
      if (userInfo != null) break;
    }

    _eMail = userInfo['e-mail'];
    _username = userInfo['username'];
    _profileUrl = userInfo['profile_image_url'];
    _userChatList = userInfo['userChatList'];

    notifyListeners();
  }

  void clearUserInfo() {
    _eMail = null;
    _username = null;
    _profileUrl = null;
    _userChatList = null;
    notifyListeners();
  }
}
