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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/feature/auth/presentation/components/my_button.dart';
import 'package:social_media/feature/auth/presentation/components/my_text_field.dart';
import 'package:social_media/feature/auth/presentation/cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final pwController = TextEditingController();

    // login button pressed
    void login() {
      // prepare email and pw
      final String email = emailController.text;
      final String pw = pwController.text;
      // auth cubit
      final authCubit = context.read<AuthCubit>();

      // ensure the email and pw field are not empty
      if (email.isNotEmpty && pw.isNotEmpty) {
        authCubit.login(email, pw);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please enter both email and password")));
      }
    }

    @override
    void dispose() {
      emailController.dispose();
      pwController.dispose();
      super.dispose();
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 50),
              // welcome back message
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: pwController,
                hintText: 'Password',
                obscureText: true,
              ),
              // Button login
              const SizedBox(height: 25),
              MyButton(
                text: 'login',
                onTap: login,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Not a member? ",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
