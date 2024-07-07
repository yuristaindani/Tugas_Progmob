import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditVolunteerPage extends StatefulWidget {
  const EditVolunteerPage({Key? key}) : super(key: key);

  @override
  _EditVolunteerPageState createState() => _EditVolunteerPageState();
}

class _EditVolunteerPageState extends State<EditVolunteerPage> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  bool isLoading = false;
  late Volunteer volunteer;
  late int id;
  late int statusAktifValue; // Radio button value

  final TextEditingController noIndukController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    statusAktifValue = 1; // Default value for radio button (Aktif)
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      id = args as int;
      fetchVolunteerDetails(id);
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  String convertToApiDateFormat(String date) {
    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  Future<void> fetchVolunteerDetails(int id) async {
    setState(() {
      isLoading = true;
    });

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
        setState(() {
          volunteer = Volunteer.fromJson(volunteerData);
          if (volunteer != null) {
            noIndukController.text = volunteer.nomorInduk;
            namaController.text = volunteer.nama;
            alamatController.text = volunteer.alamat;
            teleponController.text = volunteer.telepon;
            tglLahirController.text = formatDate(volunteer.tanggalLahir);
            statusAktifValue = volunteer.statusAktif;
          }
        });
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioError catch (e) {
      setState(() {
        isLoading = false;
      });
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your token is expired. Login Please.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> editVolunteer(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _dio.put(
        '$_apiUrl/anggota/$id',
        data: {
          'nomor_induk': noIndukController.text,
          'nama': namaController.text,
          'alamat': alamatController.text,
          'tgl_lahir': convertToApiDateFormat(tglLahirController.text),
          'telepon': teleponController.text,
          'status_aktif': statusAktifValue,
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Volunteer details updated successfully."),
              actions: <Widget>[
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushReplacementNamed(context, '/detail', arguments: volunteer.id);
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to update volunteer details. Please try again later."),
              actions: <Widget>[
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      String errorMessage = 'Failed to update volunteer details.';
      if (e.response?.statusCode == 409) {
        errorMessage = 'Nomor Induk already in use.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: <Widget>[
              MaterialButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Volunteer',
          style: GoogleFonts.urbanist(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                          radius: 50,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(
                                'assets/images/avatar.png'), // Ganti dengan path gambar profil Anda
                          ),
                        ),
                  SizedBox(height: 20),
                  _buildTextField(label: 'No Induk', controller: noIndukController),
                  _buildTextField(label: 'Nama Lengkap', controller: namaController),
                  _buildTextField(label: 'Alamat', controller: alamatController),
                  _buildTextField(label: 'Tanggal Lahir', controller: tglLahirController),
                  _buildTextField(label: 'Telepon', controller: teleponController),
                  _buildStatusRadioButtons(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        minWidth: 150,
                        height: 60,
                        onPressed: isLoading ? null : () => editVolunteer(context),
                        color: Color.fromARGB(255, 28, 95, 30),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Simpan',
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 28, 95, 30),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 28, 95, 30),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 15), // Adjust vertical padding
          ),
          style: GoogleFonts.urbanist(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildStatusRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Radio(
              value: 1,
              groupValue: statusAktifValue,
              onChanged: (value) {
                setState(() {
                  statusAktifValue = value as int;
                });
              },
            ),
            Text('Aktif', style: GoogleFonts.urbanist(fontSize: 16)),
            SizedBox(width: 20),
            Radio(
              value: 0,
              groupValue: statusAktifValue,
              onChanged: (value) {
                setState(() {
                  statusAktifValue = value as int;
                });
              },
            ),
            Text('Tidak Aktif', style: GoogleFonts.urbanist(fontSize: 16)),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class Volunteer {
  final int id;
  final String nomorInduk;
  final String nama;
  final String alamat;
  final String tanggalLahir;
  final String telepon;
  final int statusAktif;

  Volunteer({
    required this.id,
    required this.nomorInduk,
    required this.nama,
    required this.alamat,
    required this.tanggalLahir,
    required this.telepon,
    required this.statusAktif,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'],
      nomorInduk: json['nomor_induk'].toString(),
      nama: json['nama'],
      alamat: json['alamat'],
      tanggalLahir: json['tgl_lahir'],
      telepon: json['telepon'],
      statusAktif: json['status_aktif'],
    );
  }
}
