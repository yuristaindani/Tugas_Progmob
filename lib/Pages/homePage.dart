import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/components/searchBar.dart';
import 'package:dio/dio.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Map<String, String>> users = [
    {'name': 'Rose Potter', 'email': 'rose@gmail.com'},
    {'name': 'Harry Potter', 'email': 'harrypotter@gmail.com'},
    {'name': 'Draco Malfoy', 'email': 'malfoydraco@gmail.com'},
    {'name': 'Hermoine Granger', 'email': 'missgranger@gmail.com'},
    {'name': 'Ron Weasly', 'email': 'ronweasly@gmail.com'},
    {'name': 'Luna Lovegood', 'email': 'lovegood@gmail.com'},
    {'name': 'Lily Potter', 'email': 'lilypotter@gmail.com'},
    {'name': 'Albus Dumbledore', 'email': 'dumbledore@gmail.com'},
  ];

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text('List Users',
          style: GoogleFonts.urbanist(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: [

                //Search Bar
                Container(
                  width: 2000,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50)),
                  child: SearchThing(),
                ),

                SizedBox(
                  height: 20,
                ),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: 90,
                        width: 2000,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color.fromARGB(255, 28, 95, 30)),
                          color: Color.fromARGB(255, 28, 95, 30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(user['name'] ?? '',
                              style: GoogleFonts.urbanist(
                                fontSize: 30,
                                color: Colors.white
                              ),),
                              Text(user['email'] ?? '',
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: Colors.white
                              ),),
                          ],),
                        ),
                      )); 
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

      //tombol Navbar
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true, // Tampilkan label item yang dipilih
        showUnselectedLabels: true, // Tampilkan label item yang tidak dipilih
        selectedItemColor: Color.fromARGB(255, 28, 95, 30), // Warna teks untuk item yang dipilih
        unselectedItemColor: Colors.grey, // Warna teks untuk item yang tidak dipilih
        currentIndex: _selectedIndex,
        onTap:(index) => {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
        })},
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
