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

    setState(() {
      isLoading = true;
    });

    try {
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Volunteer has been successfully edited."),
              actions: <Widget>[
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Navigator.pushReplacementNamed(context, '/daftarVolunteer'); // Navigasi ke halaman beranda
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
              content: Text("Failed to edit. Please try again later."),
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
    } on DioException catch (e) {
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
    }
  }
}
