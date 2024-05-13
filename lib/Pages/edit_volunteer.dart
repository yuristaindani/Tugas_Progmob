import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/Pages/listVolunteer.dart';
import 'package:get_storage/get_storage.dart';

class EditVolunteerPage extends StatefulWidget {
  const EditVolunteerPage({Key? key}) : super(key: key);

  @override
  _EditVolunteerPageState createState() => _EditVolunteerPageState();
}

class _EditVolunteerPageState extends State<EditVolunteerPage> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Volunteer? volunteer;
  bool isLoading = false;

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
      fetchMemberDetails(id);
    }
  }

  Future<void> fetchMemberDetails(int id) async {
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
      isLoading = false;
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
        title: Text('Edit Volunteer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: noIndukController,
              decoration: InputDecoration(labelText: 'No Induk'),
            ),
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextFormField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextFormField(
              controller: tglLahirController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir (YYYY-MM-DD)'),
            ),
            TextFormField(
              controller: teleponController,
              decoration: InputDecoration(labelText: 'Telepon'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : () => editMemberDetails(context),
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editMemberDetails(BuildContext context) async {
  String noInduk = noIndukController.text.trim();
  String nama = namaController.text.trim();
  String alamat = alamatController.text.trim();
  String tglLahir = tglLahirController.text.trim();
  String telepon = teleponController.text.trim();

  final response = await _dio.put(
    '$_apiUrl/anggota/${volunteer?.id}',
    data: {
      'nomor_induk': noInduk,
      'nama': nama,
      'alamat': alamat,
      'tgl_lahir': tglLahir,
      'telepon': telepon,
    },
    options: Options(
      headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
    ),
  );

  if (response.statusCode == 200) {
    // Data berhasil diperbarui
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data berhasil diperbarui.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pushReplacementNamed(context, '/daftarVolunteer');
  } else {
    // Terjadi kesalahan saat memperbarui data
    print('Terjadi kesalahan: ${response.statusCode}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Terjadi kesalahan saat memperbarui data. Silakan coba lagi.',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Navigator.of(context).pop(); // Tutup dialog edit
}
}