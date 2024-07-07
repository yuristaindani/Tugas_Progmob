import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailVolunteerPage extends StatefulWidget {
  const DetailVolunteerPage({Key? key}) : super(key: key);

  @override
  _DetailVolunteerPageState createState() => _DetailVolunteerPageState();
}

class _DetailVolunteerPageState extends State<DetailVolunteerPage> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Volunteer? volunteer;
  bool isLoading = false;
  int saldo = 0;

  final TextEditingController idController = TextEditingController();
  final TextEditingController noIndukController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController statusController = TextEditingController(); // Add statusController

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      int id = args as int;
      fetchVolunteerDetails(id);
      fetchSaldo(id); // Fetch saldo
    }
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
            idController.text = volunteer!.id.toString();
            noIndukController.text = volunteer!.nomorInduk;
            namaController.text = volunteer!.nama;
            alamatController.text = volunteer!.alamat;
            teleponController.text = volunteer!.telepon;
            tglLahirController.text = formatDate(volunteer!.tanggalLahir); // Format date to dd-MM-yyyy
            statusController.text =
                volunteer!.statusAktif == 1 ? 'Aktif' : 'Non Aktif'; // Set statusController value based on volunteer status
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

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  Future<void> fetchSaldo(int id) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        setState(() {
          saldo = responseData['data']['saldo'];
        });
      } else {
        print('Gagal memuat saldo: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      String errorMessage = 'Terjadi kesalahan saat mengambil saldo.';
      if (e.response?.statusCode == 404) {
        errorMessage = 'Data saldo tidak ditemukan.';
      }
      // Tampilkan pesan kesalahan dengan dialog atau snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Detail Volunteer',
        style: GoogleFonts.urbanist(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        )),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : volunteer == null
              ? Center(child: Text('Member not found'))
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
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
                        _buildDetailItem('No Induk', noIndukController),
                        _buildDetailItem('Nama Lengkap', namaController),
                        _buildDetailItem('Alamat', alamatController),
                        _buildDetailItem('Tanggal Lahir', tglLahirController),
                        _buildDetailItem('Telepon', teleponController),
                        _buildStatusItem(volunteer!.statusAktif), // Update status display
                        _buildSaldoItem(saldo), // Update saldo display
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              minWidth: 150,
                              height: 60,
                              onPressed: () {
                                Navigator.pushNamed(context, '/detailtabungan',
                                    arguments: volunteer?.id);
                              },
                              color: Color.fromARGB(255, 28, 95, 30),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "History Transaksi",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              minWidth: 150,
                              height: 60, 
                              onPressed: () {
                                if (volunteer!.statusAktif == 1) {
                                  Navigator.pushNamed(context,'/addtabungan', arguments: {
                                    'id': volunteer?.id,
                                    'nomor_induk': volunteer?.nomorInduk,
                                    'nama': volunteer?.nama,
                                  },);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Member Tidak Aktif!'),
                                        content: Text('Tidak dapat melakukan transaksi.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); 
                                              },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            color: Color.fromARGB(255, 28, 95, 30),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "Add Transaksi",
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
                ),
    );
  }

  Widget _buildDetailItem(String label, TextEditingController controller) {
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 28, 95, 30)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            controller.text,
            style: GoogleFonts.urbanist(
              fontSize: 16, 
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(int statusAktif) {
    bool isActive = statusAktif == 1;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? Color.fromARGB(244, 75, 228, 83) : Colors.redAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            isActive ? 'Status Aktif' : 'Status Tidak Aktif',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildSaldoItem(int saldo) {
  final formatter = NumberFormat('#,###'); // Membuat formatter dengan format ribuan
  String formattedSaldo = formatter.format(saldo); // Menggunakan formatter untuk saldo

  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Color.fromARGB(244, 75, 228, 83),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      'Saldo: Rp $formattedSaldo', // Menambahkan format 'Rp' atau sesuai kebutuhan
      style: GoogleFonts.urbanist(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
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
  final int statusAktif; // Add status field

  Volunteer({
    required this.id,
    required this.nomorInduk,
    required this.nama,
    required this.alamat,
    required this.tanggalLahir,
    required this.telepon,
    required this.statusAktif, // Add status parameter
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'],
      nomorInduk: json['nomor_induk'].toString(),
      nama: json['nama'],
      alamat: json['alamat'],
      tanggalLahir: json['tgl_lahir'],
      telepon: json['telepon'],
      statusAktif: json['status_aktif'], // Initialize status from JSON
    );
  }
}
