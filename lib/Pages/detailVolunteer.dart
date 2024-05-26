import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_application_1/components/myTextFields.dart'; // Import MyTextFields

class DetailVolunteerPage extends StatefulWidget {
  const DetailVolunteerPage({Key? key}) : super(key: key);

  @override
  _DetailVolunteerPage createState() => _DetailVolunteerPage();
}

class _DetailVolunteerPage extends State<DetailVolunteerPage> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Volunteer? volunteer;
  bool isLoading = false;

  final TextEditingController idController = TextEditingController();
  final TextEditingController noIndukController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      int id = args as int;
      fetchvolunteerDetails(id);
    }
  }

  Future<void> fetchvolunteerDetails(int id) async {
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
            tglLahirController.text = volunteer!.tanggalLahir;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Volunteer'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDetailItem('ID', idController),
                  _buildDetailItem('No Induk', noIndukController),
                  _buildDetailItem('Nama Lengkap', namaController),
                  _buildDetailItem('Alamat', alamatController),
                  _buildDetailItem('Tanggal Lahir', tglLahirController),
                  _buildDetailItem('Telepon', teleponController),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailItem(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: 2000,
            height: 40,
            child: MyTextFields(
              controller: controller, // Use the provided controller
              hintText: '', // Empty hintText
              obscureText: false, // Not using obscureText in this case
              enabled: false, // Make it non-editable and non-clickable
            ),
          ),
        ],
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

  Volunteer({
    required this.id,
    required this.nomorInduk,
    required this.nama,
    required this.alamat,
    required this.tanggalLahir,
    required this.telepon,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'],
      nomorInduk: json['nomor_induk'].toString(),
      nama: json['nama'],
      alamat: json['alamat'],
      tanggalLahir: json['tgl_lahir'],
      telepon: json['telepon'].toString(),
    );
  }
}
