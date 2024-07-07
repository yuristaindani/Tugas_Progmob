import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:get_storage/get_storage.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // State to track loading status

  // Text editing controllers
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    fullnameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tulisan Register
                    Text(
                      'Register',
                      style: GoogleFonts.urbanist(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Enter your personal information!',
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),

                    // Kolom Fullname
                    SizedBox(height: 30),
                    Text(
                      'Fullname',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    MyTextFields(
                      controller: fullnameController,
                      hintText: 'Fullname',
                      obscureText: false,
                      enabled: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your fullname';
                        }
                        return null;
                      },
                    ),

                    // Kolom Username
                    SizedBox(height: 20),
                    Text(
                      'Username',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    MyTextFields(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                      enabled: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),

                    // Kolom Email
                    SizedBox(height: 20),
                    Text(
                      'Email',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    MyTextFields(
                      controller: emailController,
                      hintText: 'Email',
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

                    // Kolom Phone
                    SizedBox(height: 20),
                    Text(
                      'Phone',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    MyTextFields(
                      controller: phoneController,
                      hintText: 'Phone',
                      obscureText: false,
                      enabled: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a valid phone number';
                        }
                        // You can add more validation logic here if needed
                        return null;
                      },
                    ),

                    // Kolom Password
                    SizedBox(height: 20),
                    Text(
                      'Password',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    MyTextFields(
                      controller: passwordController,
                      hintText: 'Password',
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

                    // Kolom Confirm Password
                    SizedBox(height: 20),
                    Text(
                      'Confirm Password',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    MyTextFields(
                      controller: confirmpasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      enabled: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    // Tombol Sign Up
                    SizedBox(height: 50),
                    Center(
                      child: Container(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true; // Set loading state to true
                            });
                            goRegister(context);
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
                          'Sign Up',
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),),
                    

                    // Tombol Login
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 3),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              'Login',
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  void goRegister(BuildContext context) async {
    try {
      final _response = await _dio.post(
        '$_apiUrl/register',
        data: {
          'name': fullnameController.text,
          'username': usernameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'password': passwordController.text,
          'password_confirmation': confirmpasswordController.text,
        },
      );

      print(_response.data);

      // Menyimpan token ke storage jika registrasi berhasil
      _storage.write('token', _response.data['data']['token']);

      // Menampilkan dialog sukses
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Text('Your registration was successful.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } on DioError catch (e) {
      String errorMessage = 'Registration failed. Please try again.';
      if (e.response?.statusCode == 422) {
        if (e.response?.data['errors']?['email'] != null) {
          errorMessage = 'Email is already registered.';
        } else if (e.response?.data['errors']?['email_format'] != null) {
          errorMessage = 'Invalid email format.';
        } else {
          errorMessage = 'Validation error. Please check your input fields.';
        }
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Internal server error. Please try again later.';
      }

      // Menampilkan dialog error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Failed'),
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
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }
}
