import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/components/searchBar.dart';

class VolunteerListPage extends StatefulWidget {
  @override
  _VolunteerListPageState createState() => _VolunteerListPageState();
}

class _VolunteerListPageState extends State<VolunteerListPage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  int _selectedIndex = 1;
  bool isUserNotFound = false;
  
  List<Volunteer> volunteerList = [];
  bool isLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    getVolunteerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Volunteer List',
          style: GoogleFonts.urbanist(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        automaticallyImplyLeading: false,
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
                        // Panggil kembali metode getVolunteerList() setiap kali ada perubahan pencarian
                        getVolunteerList();
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                
                isLoading
                  ? Center(child: CircularProgressIndicator())
                  : volunteerList.isEmpty
                      ? isUserNotFound
                          ? Center(
                              child: Text(
                                'Pengguna tidak ditemukan',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : Container()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: volunteerList.length,
                          itemBuilder: (context, index) {
                            final volunteer = volunteerList[index];
                            return Padding(
                              padding: EdgeInsets.all(10),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                tileColor: Color.fromARGB(255, 28, 95, 30),
                                title: Text(
                                  volunteer.nama ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  volunteer.alamat ?? '',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, '/detail', arguments: volunteer.id);
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/edit', arguments: volunteer.id);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.white,
                                      onPressed: () {
                                        deleteVolunteer(volunteer.id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        tooltip: 'Add Volunteer',
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Color.fromARGB(255, 28, 95, 30),
      ),
    );
  }


  void getVolunteerList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final userData = responseData['data']['anggotas'];
        if (userData is List) {
          setState(() {
            volunteerList = userData
                .map((volunteerJson) => Volunteer.fromJson(volunteerJson))
                .where((volunteer) =>
                    volunteer.nama.toLowerCase().contains(searchQuery.toLowerCase())) // Filter berdasarkan query pencarian
                .toList();
            isUserNotFound = volunteerList.isEmpty;
          });
        }
      } else {
        print('Error: API request failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteVolunteer(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus volunteer ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      try {
        final response = await _dio.delete(
          '$_apiUrl/anggota/$id',
          options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
          ),
        );

        if (response.statusCode == 200) {
          // Refresh volunteer list after deletion
          getVolunteerList();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Volunteer berhasil dihapus.'),
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
          print('Volunteer with ID $id deleted successfully.');
        } else {
          print('Error deleting volunteer: ${response.statusCode}');
        }
      } on DioError catch (e) {
        print('Terjadi kesalahan: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat menghapus volunteer.'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class Volunteer {
  final int id;
  final String nomorInduk;
  final String nama;
  final String alamat;
  final String tanggalLahir;
  final String telepon;
  final int status;

  Volunteer({
    required this.id,
    required this.nomorInduk,
    required this.nama,
    required this.alamat,
    required this.tanggalLahir,
    required this.telepon,
    required this.status,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'] ?? 0,
      nomorInduk: json['nomor_induk'].toString(),
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      tanggalLahir: json['tgl_lahir'] ?? '',
      telepon: json['telepon'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}
