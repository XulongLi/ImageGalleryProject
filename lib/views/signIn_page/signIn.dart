import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_gallery/views/Authentication/Authentication_service.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Login Page', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Container(
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ),
          Container(
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
            ),
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
            },
            child: Text("Sign In"),
          ),
          SizedBox(height: 20),
          Text("Don't have an account?"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signUp(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
            },
            child: Text("Sign Up"),
          )
        ],
      ),
    );
  }
}
