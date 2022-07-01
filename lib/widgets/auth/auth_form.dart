import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your e-mail adress.";
    }

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);

    if (!emailValid) {
      return "Your e-mail adress is not valid.";
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password.";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters.";
    }

    return null;
  }

  String? _validateUsername(String? value) {
    if (_isLogin) {
      return null;
    }

    if (value == null || value.isEmpty) {
      return "Please enter a username.";
    }

    if (value.length < 4) {
      return "Username must be at least 4 characters.";
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (_isLogin) {
      return null;
    }

    if (value == null || value.isEmpty) {
      return "Please enter your confirm password.";
    }

    if (value != _passwordController.text) {
      return "Please check your confirm password.";
    }

    return null;
  }

  Future<void> _login() async {
    final bool isValid = _formKey.currentState!.validate();
    print(isValid);

    if (!isValid) {
      return;
    }

    try {
      final UserCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(UserCredential.user!.uid)
          .set({"last_login": Timestamp.now()});
    } on FirebaseAuthException catch (error) {
      print(error.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message!),
        ),
      );
    }
  }

  Future<void> _signUp() async {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "e-mail": _emailController.text.trim(),
        "username": _usernameController.text.trim(),
        "last_login": Timestamp.now()
      });
    } on FirebaseAuthException catch (error) {
      print(error.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          elevation: 4,
          color: Colors.green[600],
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    key: const ValueKey("e-mail"),
                    validator: _validateEmail,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                        "E-MAIL",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey("username"),
                      validator: _validateUsername,
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          "User Name",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  if (!_isLogin)
                    const SizedBox(
                      height: 20,
                    ),
                  TextFormField(
                    key: const ValueKey("password"),
                    validator: _validatePassword,
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                        "Password",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('confirmPassword'),
                      validator: _confirmPasswordValidator,
                      obscureText: true,
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          "Confirm Password",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  if (!_isLogin)
                    const SizedBox(
                      height: 20,
                    ),
                  ElevatedButton(
                      onPressed: _isLogin ? _login : _signUp,
                      child: Text(_isLogin ? "Login" : "Sign Up")),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                          _isLogin ? "Don't have an account yet?" : "Login"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
