import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_info.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Future<void> _showLogoutDialog(BuildContext context) async {
    final isLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            'Do you want to logout?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop<bool>(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop<bool>(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (isLogout!) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Consumer<UserInformation>(
            builder: (context, userInfo, child) => CircleAvatar(
              backgroundImage: NetworkImage(userInfo.profileUrl!),
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              await _showLogoutDialog(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(Icons.logout),
              ],
            ),
          )
        ],
      ),
    );
  }
}
