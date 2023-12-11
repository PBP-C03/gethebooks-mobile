// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gethebooks/screens/menu.dart'; 
import 'package:gethebooks/authentication/user.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  double _position = 500; // Awalnya di luar layar
  
  @override
  void initState() {
    super.initState();
    // Animasi dimulai setelah build pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _position = 0; // Geser ke posisi akhir
      });
    });
  }

  // Function to handle login logic
  Future<void> handleLogin() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final request = context.read<CookieRequest>();
    final response = await request.login("http://127.0.0.1:8000/auth/login/", {
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
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500), // Durasi animasi
        curve: Curves.easeOut, // Tipe animasi
        transform: Matrix4.translationValues(0, _position, 0), // Transformasi posisi  
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.yellow[100], // Light yellow background
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
            Image.asset(
              'assets/images/GethebooksLogo.png',
              width: 150,
              height: 150,
            ),
              const SizedBox(height: 20),
              const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
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
      )
    );
  }
}