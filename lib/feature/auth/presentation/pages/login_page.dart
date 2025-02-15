/*

LOGIN PAGE

On this page, an existing user can login with their:
-email
-password
---------------------------------------
Once the user successfully logs in, they will be redireacted to home page.

If user dose'nt have an account, they can go to register page from here to create one

 */

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
    );
  }
}