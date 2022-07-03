import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart';
import '../widgets/animated_gradient_background.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: const AuthForm(),
      ),
    );
  }
}
