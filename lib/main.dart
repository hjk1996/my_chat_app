import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import 'screens/chat_list_screen.dart';
import './screens/search_screen.dart';
import './screens/creat_chat_room_screen.dart';
import './providers/user_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserInformation(),
      child: MaterialApp(
          title: 'My Chat App',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          routes: {
            SearchScreen.routeName: (context) => const SearchScreen(),
            CreateChatRoomScreen.routeName: (context) =>
                const CreateChatRoomScreen()
          },
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, authSnapshot) {
                if (authSnapshot.hasData) {
                  return const ChatScreen();
                }

                return const AuthScreen();
              })),
    );
  }
}
