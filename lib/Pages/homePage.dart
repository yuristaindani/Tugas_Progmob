import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/components/searchBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Home',
          style: GoogleFonts.urbanist(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false, // Menyembunyikan tombol kembali
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              children: [
                // Search Bar
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: SearchThing(
                    onSearch: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                // More Widgets Here
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Color.fromARGB(255, 28, 95, 30),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/homepage');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/daftarVolunteer');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/listbunga');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/profile');
                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? Color.fromARGB(255, 28, 95, 30) : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: _selectedIndex == 1 ? Color.fromARGB(255, 28, 95, 30) : Colors.grey),
            label: 'Member',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist, color: _selectedIndex == 2 ? Color.fromARGB(255, 28, 95, 30) : Colors.grey),
            label: 'Bunga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _selectedIndex == 3 ? Color.fromARGB(255, 28, 95, 30) : Colors.grey),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
