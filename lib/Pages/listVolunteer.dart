import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class VolunteerListPage extends StatefulWidget {
  @override
  _VolunteerListPageState createState() => _VolunteerListPageState();
}

class _VolunteerListPageState extends State<VolunteerListPage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  
  List<Volunteer> volunteerList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getVolunteerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: volunteerList.length,
              itemBuilder: (context, index) {
                final volunteer = volunteerList[index];
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
                      goVolunteerDetail(volunteer.id);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/edit', arguments: volunteer?.id);
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
                .map((volunteerJson) => Volunteer.fromJson({
                  "id": volunteerJson["id"],
                  "nomor_induk": volunteerJson["nomor_induk"],
                  "nama": volunteerJson["nama"],
                  "alamat": volunteerJson["alamat"],
                  "tgl_lahir": volunteerJson["tgl_lahir"],
                  "telepon": volunteerJson["telepon"],
                  "status": volunteerJson["status"], // Pastikan status sudah ada di JSON response
                }))
                .toList();
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

  void goVolunteerDetail(int id) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final volunteerData = responseData['data']['anggota'];
        Volunteer? selectedVolunteer = Volunteer.fromJson(volunteerData);

        if (selectedVolunteer != null) {
          String statusText =
              selectedVolunteer.status == 1 ? 'Active' : 'Non Active';

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Detail Volunteer"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("ID: ${selectedVolunteer.id ?? 'Not Found'}"),
                    Text("Nama: ${selectedVolunteer.nama ?? 'Not Found'}"),
                    Text("Alamat: ${selectedVolunteer.alamat ?? 'Not Found'}"),
                    Text("Tanggal Lahir: ${selectedVolunteer.tanggalLahir ?? 'Not Found'}"),
                    Text("Telepon: ${selectedVolunteer.telepon ?? 'Not Found'}"),
                    Text("Status: $statusText"),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Tutup"),
                  ),
                ],
              );
            },
          );
        } else {
          print("Data volunteer tidak ditemukan.");
        }
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    }
  }

  void deleteVolunteer(int id) async {
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
        print('Volunteer with ID $id deleted successfully.');
      } else {
        print('Error deleting volunteer: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
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