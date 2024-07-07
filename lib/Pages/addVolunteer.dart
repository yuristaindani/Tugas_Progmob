import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class AddVolunteerPage extends StatefulWidget {
  AddVolunteerPage({super.key});

  @override
  State<AddVolunteerPage> createState() => _AddVolunteerPageState();
}

class _AddVolunteerPageState extends State<AddVolunteerPage> {
  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final noIndukController = TextEditingController();
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final phoneController = TextEditingController();
  DateTime? selectedDate;
  final _formKey = GlobalKey<FormState>(); // GlobalKey untuk form
  bool _isLoading = false; // State untuk indikator loading

  @override
  void initState() {
    super.initState();
    _getLastNoInduk();
  }

  Future<void> _getLastNoInduk() async {
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
          final nomorIndukList = userData
              .map((memberJson) => memberJson['nomor_induk'] as int)
              .toList();
          final int lastNoInduk = nomorIndukList.isNotEmpty
              ? nomorIndukList.reduce((curr, next) => curr > next ? curr : next)
              : 0;
          setState(() {
            noIndukController.text = (lastNoInduk + 1).toString();
          });
        }
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioError catch (e) {
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
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator()) // Indikator loading
              : Form(
                  key: _formKey, // Menghubungkan GlobalKey dengan Form
                  child: Column(
                    children: [
                      // Tulisan Register
                      Text(
                        'Add more Volunteers',
                        style: GoogleFonts.urbanist(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Enter your personal informations!',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),

                      // Kolom Fullname
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Fullname',
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2000,
                        height: 40,
                        child: MyTextFields(
                          controller: namaController,
                          hintText: 'Fullname',
                          obscureText: false,
                          enabled: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your fullname';
                            }
                            return null;
                          },
                        ),
                      ),

                      // Kolom Alamat
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Address',
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2000,
                        height: 40,
                        child: MyTextFields(
                          controller: alamatController,
                          hintText: 'Address',
                          obscureText: false,
                          enabled: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                      ),

                      // Kolom Date of Birth
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Date of Birth',
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2000,
                        height: 40,
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: selectedDate != null
                                ? dateFormat.format(selectedDate!)
                                : '',
                          ),
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 28, 95, 30)),
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Select Date of Birth',
                            hintStyle: GoogleFonts.urbanist(
                                color: Colors.grey.shade400,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      // Kolom Phone
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Phone',
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2000,
                        height: 40,
                        child: MyTextFields(
                          controller: phoneController,
                          hintText: 'Phone',
                          obscureText: false,
                          enabled: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ),

                      // Tombol add
                      SizedBox(height: 50),
                      Container(
                        width: 350,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              goAddVolunteer(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 28, 95, 30)),
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Color.fromARGB(255, 28, 95, 30),
                          ),
                          child: Text(
                            'Add Volunteer',
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void goAddVolunteer(BuildContext context) async {
    setState(() {
      _isLoading = true; // Mengatur state loading menjadi true
    });

    String nomor_induk = noIndukController.text;
    String nama = namaController.text;
    String alamat = alamatController.text;
    String telepon = phoneController.text;
    String tgl_lahir =
        selectedDate != null ? selectedDate!.toIso8601String() : '';

    try {
      final _response = await _dio.post(
        '${_apiUrl}/anggota',
        options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'}
        ),
        data: {
          'nomor_induk': int.parse(nomor_induk),
          'nama': nama,
          'alamat': alamat,
          'tgl_lahir': tgl_lahir,
          'telepon': telepon,
          'status_aktif': 1,
        },
      );

      if (_response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Volunteer has been successfully added."),
              actions: <Widget>[
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.pushNamed(context, '/daftarVolunteer'); // Navigasi ke halaman beranda
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
              content: Text("Failed to add. Please try again later."),
              actions: <Widget>[
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      String errorMessage = 'Nomor Induk is already in use. Please try again.';
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
                  Navigator.of(context).pop(); // Tutup dialog
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false; // Mengatur state loading kembali menjadi false setelah selesai
      });
    }
  }
}
