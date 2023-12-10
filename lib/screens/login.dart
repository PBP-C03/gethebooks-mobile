// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gethebooks/screens/menu.dart'; 
import 'package:gethebooks/screens/user.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle login logic
  Future<void> handleLogin() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final request = context.read<CookieRequest>();
    final response = await request.login("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/auth/login/", {
      'username': username,
      'password': password,
    });

    if (request.loggedIn) {
      final String message = response['message'];
      final String uname = response['username'];
      user = UserData(isLoggedIn: true, username: uname);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(username: uname)),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text("$message Selamat datang, $uname.")));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Gagal'),
          content: Text(response['message'] ?? 'Username atau password salah.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.yellow[100], // Light yellow background
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(Icons.account_circle_outlined,
                size: 100), // Placeholder logo GeTheBooks nanti
            const SizedBox(height: 20),
            Text(
              'LOGIN',
              style: TextStyle(
                color: Colors.yellow[800],
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Forgot Password logic...
                },
                child: Text('Forgot Password?',
                    style: TextStyle(color: Colors.blue[800])),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleLogin, // Call the login handler
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[300],
                fixedSize: Size(MediaQuery.of(context).size.width - 250, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Or continue with social account',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Google login logic...
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Google'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Facebook login logic...
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Facebook'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // Register logic...
              },
              child: Text('Don\'t have an account? REGISTER',
                  style: TextStyle(color: Colors.blue[800])),
            ),
          ],
        ),
      ),
    );
  }
}
