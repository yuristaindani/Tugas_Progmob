import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Pages/addVolunteer.dart';
import 'package:flutter_application_1/Pages/detailVolunteer.dart';
import 'package:flutter_application_1/Pages/edit_volunteer.dart';
import 'package:flutter_application_1/Pages/jenisTransaksi.dart';
import 'package:flutter_application_1/Pages/listVolunteer.dart';
import 'package:flutter_application_1/Pages/profilePage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_1/Pages/homePage.dart';
import 'package:flutter_application_1/Pages/landingPage.dart';
import 'package:flutter_application_1/Pages/loginPage.dart';
import 'package:flutter_application_1/Pages/registerPage.dart';
import 'package:flutter_application_1/Pages/ListTabungan.dart';
import 'package:flutter_application_1/Pages/AddTabunganPage.dart';
import 'package:flutter_application_1/Pages/detailTabungan.dart';
import 'package:flutter_application_1/Pages/lihatSaldo.dart';
import 'package:flutter_application_1/Pages/listSettingBunga.dart';
import 'package:flutter_application_1/Pages/addSettingBunga.dart';


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
        '/daftarVolunteer': (context) => VolunteerListPage(),
        '/edit': (context) => EditVolunteerPage(),
        '/detail': (context) => DetailVolunteerPage(),
        '/transaksi': (context) => ListTabunganPage(),
        '/addtabungan': (context) =>AddTabunganPage(),
        '/jenistransaksi': (context) => TransaksiView(),
        '/detailtabungan': (context) =>ListDetailTabunganPage(),
        '/saldotabungan': (context) =>LihatSaldoPage(),
        '/listbunga': (context) =>ListSettingBungaPage(),
        '/addbunga': (context) =>AddSettingBungaPage(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}


