import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/feature/auth/presentation/cubits/auth_cubit.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final pwController = TextEditingController();
    final nameController = TextEditingController();
    final confirmController = TextEditingController();

    void register() {
      final String emailValue = emailController.text;
      final String pwValue = pwController.text;
      final String nameValue = nameController.text;
      final String confirmValue = confirmController.text;

      // auth cubit
      final authCubit = context.read<AuthCubit>();

      // ensure the field aren't empty
      if (emailValue.isNotEmpty &&
          pwValue.isNotEmpty &&
          confirmValue.isNotEmpty &&
          nameValue.isNotEmpty) {
        if (pwValue != confirmValue) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Passwords do not match!")));
        } else {
          authCubit.register(nameValue, emailValue, pwValue);
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please complete all field")));
      }
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
                "Let's create a account for you",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
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
              const SizedBox(height: 25),
              MyTextField(
                controller: confirmController,
                hintText: 'Confirm password',
                obscureText: true,
              ),
              // Button login
              const SizedBox(height: 25),
              MyButton(
                text: 'register',
                onTap: register,
              ),
              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Already a member? ",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      "login now",
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
