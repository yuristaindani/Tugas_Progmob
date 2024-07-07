import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  // Text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // State to track loading status

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Tulisan WELCOME
                      Text(
                        'Welcome back! Glad to see you, Again!',
                        style: GoogleFonts.urbanist(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Kolom Username
                      SizedBox(height: 70),
                      Container(
                        width: 2000,
                        height: 50,
                        child: MyTextFields(
                          controller: emailController,
                          hintText: 'Enter your email',
                          obscureText: false,
                          enabled: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Kolom Password
                      SizedBox(height: 15),
                      Container(
                        width: 2000,
                        height: 50,
                        child: MyTextFields(
                          controller: passwordController,
                          hintText: 'Enter your password',
                          obscureText: true,
                          enabled: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Tulisan lupa password
                      SizedBox(height: 8),
                      Row(
                        children: [
                          SizedBox(width: 230),
                          Text(
                            'Forgot Password?',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      // Tombol login
                      SizedBox(height: 50),
                      Container(
                        width: 350,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() {
                                _isLoading = true; // Set loading state to true
                              });
                              goLogin(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color.fromARGB(255, 28, 95, 30)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: Color.fromARGB(255, 28, 95, 30),
                          ),
                          child: Text(
                            'Login',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Tulisan pilihan login
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                              thickness: 0.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Or Login with',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.shade400,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      // Pilihan login
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 108,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                              image: DecorationImage(
                                image: AssetImage('assets/images/facebook.png'),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: 108,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                              image: DecorationImage(
                                image: AssetImage('assets/images/google.png'),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: 108,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                              image: DecorationImage(
                                image: AssetImage('assets/images/apple.png'),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ],
                      ),
                      // Tulisan Register Now
                      SizedBox(height: 80),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text(
                                'Register Now',
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 28, 95, 30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Indikator loading di tengah layar
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void goLogin(BuildContext context) async {
    try {
      final _response = await _dio.post(
        '${_apiUrl}/login',
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      print(_response.data);
      _storage.write('token', _response.data['data']['token']);
      Navigator.pushNamed(context, '/homepage');
    } on DioError catch (e) {
      String errorMessage = 'Invalid email or password. Please try again.';
      if (e.response?.statusCode == 401) {
        errorMessage = 'Invalid email or password. Please check your credentials.';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Internal server error. Please try again later.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed!'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      print('${e.response} - ${e.response?.statusCode}');
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
