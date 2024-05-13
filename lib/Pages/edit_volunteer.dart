import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

// Define the Volunteer class at the top-level
class Volunteer {
  final int id;
  final String nomorInduk;
  final String nama;
  final String alamat;
  final String tanggalLahir;
  final String telepon;
  final int statusAktif; // Define statusAktif property

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
      id: json['id'] ?? 0,
      nomorInduk: json['nomor_induk'].toString(),
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      tanggalLahir: json['tgl_lahir'] ?? '',
      telepon: json['telepon'] ?? '',
      statusAktif: json['status'] ?? 0,
    );
  }
}

class EditVolunteerPage extends StatefulWidget {
  final Volunteer volunteer;

  const EditVolunteerPage({Key? key, required this.volunteer}) : super(key: key);

  @override
  _EditVolunteerPageState createState() => _EditVolunteerPageState();
}

class _EditVolunteerPageState extends State<EditVolunteerPage> {
  late TextEditingController nomorIndukController;
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController teleponController;
  late TextEditingController tanggalLahirController;
  late int _selectedStatus; // Nilai default status aktif

  final _dio = Dio();
  final _storage = GetStorage();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  @override
  void initState() {
    super.initState();
    nomorIndukController = TextEditingController(text: widget.volunteer.nomorInduk.toString());
    namaController = TextEditingController(text: widget.volunteer.nama);
    alamatController = TextEditingController(text: widget.volunteer.alamat);
    teleponController = TextEditingController(text: widget.volunteer.telepon);
    tanggalLahirController = TextEditingController(text: widget.volunteer.tanggalLahir);
    _selectedStatus = widget.volunteer.statusAktif;
  }

  @override
  void dispose() {
    nomorIndukController.dispose();
    namaController.dispose();
    alamatController.dispose();
    teleponController.dispose();
    tanggalLahirController.dispose();
    super.dispose();
  }

  Future<void> _updateVolunteer() async {
    try {
      final response = await _dio.put(
        '$_apiUrl/anggota/${widget.volunteer.id}',
        data: {
          'nomor_induk': nomorIndukController.text,
          'nama': namaController.text,
          'alamat': alamatController.text,
          'tgl_lahir': tanggalLahirController.text,
          'telepon': teleponController.text,
          'status_aktif': _selectedStatus,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_storage.read('token')}',
          },
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/homepage');
      } else {
        // throw DioError(response: response);
      }
    } catch (e) {
      print('Update failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Update failed. Please check your data or login again.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Volunteer',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Update Volunteer',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Expand the community reach by making the volunteers up to date',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            _buildTextField('Nomor Induk', nomorIndukController),
            SizedBox(height: 20),
            _buildTextField('Name', namaController),
            SizedBox(height: 20),
            _buildTextField('Alamat', alamatController),
            SizedBox(height: 20),
            _buildTextField('Tanggal Lahir', tanggalLahirController), // Updated label
            SizedBox(height: 20),
            _buildTextField('Telepon', teleponController),
            SizedBox(height: 20),
            _buildStatusRadio(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _updateVolunteer,
                  child: Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildStatusRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Aktif:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Radio(
              value: 1,
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value as int;
                });
              },
            ),
            Text('Aktif'),
            Radio(
              value: 0,
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value as int;
                });
              },
            ),
            Text('Non-Aktif'),
          ],
        ),
      ],
    );
  }
}
