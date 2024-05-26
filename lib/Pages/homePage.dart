import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/components/searchBar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 28, 95, 30),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add Volunteer'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.pushNamed(context, '/add');
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('List Volunteer'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.pushNamed(context, '/daftarVolunteer');
              },
            ),
             ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Transaksi Volunteer'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.pushNamed(context, '/transaksi');
              },
            ),
          ],
        ),
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
                  child: SearchThing(),
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
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/homepage');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          });
        },
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
