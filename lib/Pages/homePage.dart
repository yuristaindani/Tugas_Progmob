import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/components/searchBar.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text('ReUse',
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

                //Bagian Artikel
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 2000,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [ BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2)
                    )]
                    ),
                  child: Column(
                    children: [
                      Container(
                        width: 2000,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/artikel.png'),
                            fit: BoxFit.fill),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )
                        ),
                      ),
                      Container(
                        width: 2000,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)
                          )
                        ),
                        child: Center(
                          child: Text('Eksplorasi Kreatif: Gaya Hidup Berkelanjutan',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),),
                        ),
                      )
                    ],
                  )
                ),

                //Bagian Barang 
                SizedBox(
                    height: 20,
                  ),
                Row(
                  children: [

                  //Barang 1  
                  Container(
                    height: 250,
                    width: 165,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [ BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2)
                      )]
                      ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 115,
                          width: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/tv.png'),
                              fit: BoxFit.fitHeight )
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 170,
                          child: Column(
                          children: [
                            Text('Tv Tabung',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                            Text('Tv tabung tahun 2008',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight:FontWeight.w500,
                              color: Colors.black
                            ),),
                          ],
                        ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text('200.000',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),),
                            ),
                            SizedBox(
                              width: 15,),
                            Container(
                              child: 
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(255, 28, 95, 30)),
                                child:Icon(Icons.add, color: Colors.white,)
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  //Barang 2 
                  SizedBox(
                    width: 20,
                  ), 
                  Container(
                    height: 250,
                    width: 165,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [ BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2)
                      )]
                      ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 115,
                          width: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/mejakayu.png'),
                              fit: BoxFit.fitHeight )
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 170,
                          child: Column(
                          children: [
                            Text('Meja Kayu',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                            Text('Meja hiasan dari kayu',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight:FontWeight.w500,
                              color: Colors.black
                            ),),
                          ],
                        ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text('FREE!    ',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),),
                            ),
                            SizedBox(
                              width: 15,),
                            Container(
                              child: 
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(255, 28, 95, 30)),
                                child:Icon(Icons.add, color: Colors.white,)
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ],
                ),

                //Barang baris kedua
                SizedBox(
                    height: 20,
                  ),
                Row(
                  children: [

                  //Barang 1  
                  Container(
                    height: 250,
                    width: 165,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [ BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2)
                      )]
                      ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 115,
                          width: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/bajuelmo.png'),
                              fit: BoxFit.fitHeight )
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 170,
                          child: Column(
                          children: [
                            Text('Baju Elmo',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                            Text('Baju Elmo size XL',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight:FontWeight.w500,
                              color: Colors.black
                            ),),
                          ],
                        ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text('FREE!    ',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),),
                            ),
                            SizedBox(
                              width: 15,),
                            Container(
                              child: 
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(255, 28, 95, 30)),
                                child:Icon(Icons.add, color: Colors.white,)
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  //Barang 2 
                  SizedBox(
                    width: 20,
                  ), 
                  Container(
                    height: 250,
                    width: 165,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [ BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2)
                      )]
                      ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 115,
                          width: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/kursi kayu.png'),
                              fit: BoxFit.fitHeight )
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 170,
                          child: Column(
                          children: [
                            Text('Kursi Kayu',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                            Text('Kursi kayu hitam',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight:FontWeight.w500,
                              color: Colors.black
                            ),),
                          ],
                        ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text('50.000  ',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),),
                            ),
                            SizedBox(
                              width: 15,),
                            Container(
                              child: 
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(255, 28, 95, 30)),
                                child:Icon(Icons.add, color: Colors.white,)
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ],
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
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png', width: 24, height: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/relove.png', width: 24, height: 24),
            label: 'ReLove',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/retrade.png', width: 24, height: 24),
            label: 'ReTrade',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/rethink.png', width: 24, height: 24),
            label: 'ReThinkGreen',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/profile.png', width: 24, height: 24),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}