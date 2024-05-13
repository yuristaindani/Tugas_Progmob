import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // This widget is the root of your application.
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
              ),
              Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/1.png'), 
                  fit: BoxFit.cover)
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('R',
                    style: GoogleFonts.snippet(
                      fontSize: 30,                        
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 28, 95, 30),) 
                   ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('E',
                    style: GoogleFonts.snippet(
                      fontSize: 30,                        
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 28, 95, 30),) 
                    ),
                    SizedBox(                        
                      width: 20,
                    ),
                    Text('U',
                    style: GoogleFonts.snippet(
                      fontSize: 30,                        
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 28, 95, 30),) 
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text('S',
                    style: GoogleFonts.snippet(
                      fontSize: 30,                        
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 28, 95, 30),) 
                    ),
                    SizedBox(                        
                      width: 20,
                    ),
                    Text('E',
                    style: GoogleFonts.snippet(
                      fontSize: 30,    
                      fontWeight: FontWeight.bold,                    
                      color: Color.fromARGB(255, 28, 95, 30),) 
                    )
                  ],),
                ),
              Text('Harmonaizing Sustainability in Every Exchange!',
              style: GoogleFonts.snippet(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 28, 95, 30),),
                textAlign: TextAlign.center
              ),
              SizedBox(
                height: 200,
              ),
              Container(
                width: 350,
                height: 50,
                child: 
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context,'/login');
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
                  )),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 350,
                  height: 50,
                  child: 
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context,'/register'); 
                    },
                    style: ElevatedButton.styleFrom(
                      shape:RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.grey.shade100,
                    ), 
                    child: 
                    Text('Create Account',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    )),
                  )
                ],
          ),
        ),
        backgroundColor: Colors.white,
      );
  }
}