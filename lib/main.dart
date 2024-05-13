import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Pages/addVolunteer.dart';
import 'package:flutter_application_1/Pages/edit_volunteer.dart';
import 'package:flutter_application_1/Pages/listVolunteer.dart';
import 'package:flutter_application_1/Pages/profilePage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_1/Pages/homePage.dart';
import 'package:flutter_application_1/Pages/landingPage.dart';
import 'package:flutter_application_1/Pages/loginPage.dart';
import 'package:flutter_application_1/Pages/registerPage.dart';

Future <void> main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LandingPage(),
        '/login':(context) => LoginPage(),
        '/register':(context) => RegisterPage(),
        '/homepage': (context) => HomePage(),
        '/profile':(context) => ProfilePage(),
        '/add':(context) => AddVolunteerPage(),
        '/listVolunteer': (context) => VolunteerListPage(),
        // '/edit': (context) => EditVolunteerPage(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}


