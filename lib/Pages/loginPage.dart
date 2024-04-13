import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Pages/homePage.dart';
import 'package:flutter_application_1/Pages/registerPage.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: [

                //Tulisan WELCOME
                Text('Welcome back! Glad to see you, Again!',
                style: GoogleFonts.urbanist(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                ),

                //Kolom Username
                SizedBox(
                  height: 70,
                ),
                Container(
                  width: 2000,
                  height: 50,
                  child: MyTextFields(
                      controller: usernameController, 
                      hintText: 'Enter your username', 
                      obscureText: false,
                  ),
                ),

                //Kolom Password
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 2000,
                  height: 50,
                  child: 
                  MyTextFields(
                    controller: passwordController, 
                    hintText: 'Enter your password', 
                    obscureText: true,
                  ),
                ),

                //Tulisan lupa password
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 230,
                    ),
                    Text('Forgot Password?',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                    ),
                  ],
                ),

                //tombol login
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 350,
                  height: 50,
                  child: 
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => HomePage()),);
                    },
                    style: ElevatedButton.styleFrom(
                      shape:RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 28, 95, 30)),
                        borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Color.fromARGB(255, 28, 95, 30),
                    ), 
                    child: 
                    Text('Login',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    )
                  ),
                ),

                //tulisan pilihan login
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 0.5,) 
                   ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: 
                      Text('Or Login with',
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
                        thickness: 1,) 
                    ),
                  ],
                ),

                //Pilihan Login
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Container(
                      width: 108,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/facebook.png'),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                      width: 108,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/google.png'),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                      width: 108,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/apple.png'),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
              
              //Tulisan Register Now
                SizedBox(
                  height: 80,
                ),
                Center(
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: Colors.black
                      ),),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),);
                        },
                        child: 
                        Text('Register Now',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 28, 95, 30)
                        ),),
                      )
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}