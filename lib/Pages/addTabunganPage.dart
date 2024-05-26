import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/components/myTextFields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class AddTabunganPage extends StatefulWidget {
  const AddTabunganPage({Key? key}) : super(key: key);

  @override
  _AddTabunganPage createState() => _AddTabunganPage();
}

class _AddTabunganPage extends State<AddTabunganPage> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  late int anggotaId; // Selected anggota ID

  // Text editing controllers
  final TextEditingController trxIdController = TextEditingController();
  final TextEditingController trxNominalController = TextEditingController();

  bool isLoading = false; // Loading status

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      anggotaId = args;
    } else {
      // Handle the case where the arguments are not as expected
      anggotaId = -1; // or some default value or error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Transaksi Tabungan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Anggota ID Text
            Text(
              'Anggota ID:',
              style: GoogleFonts.lato(fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              width: 2000,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade100,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$anggotaId',
                  style: TextStyle(fontSize: 16),
                ),  
              ),
            ),
            SizedBox(height: 20),

            // Transaksi ID
            Text(
              'Transaksi ID',
              style: GoogleFonts.lato(fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              width: 2000,
              height: 40,
              child: MyTextFields(
                  controller: trxIdController,
                  hintText: 'Enter Transaksi ID',
                  obscureText: false,
                  enabled: true,
                ),
            ),
            SizedBox(height: 20),

            // Transaksi Nominal
            Text(
              'Transaksi Nominal',
              style: GoogleFonts.lato(fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              width: 2000,
              height: 40,
              child: MyTextFields(
                controller: trxNominalController,
                hintText: 'Enter Transaksi Nominal',
                obscureText: false,
                enabled: true,
              ),
            ),
            SizedBox(height: 30),

            // Button
            ElevatedButton(
              onPressed: () => insertTransaksiTabungan(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Color.fromARGB(255, 28, 95, 30)),
                    borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Color.fromARGB(255, 28, 95, 30),
                    ),
              child: Text('Submit',
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                )),
            ),

            // Loading Indicator
            SizedBox(height: 20),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Change the color
                  strokeWidth: 3, // Adjust the stroke width
                ),
              ),
          ],
        ),
      ),
    );
  }

  void insertTransaksiTabungan(BuildContext context) async {
    final trxId = trxIdController.text;
    final trxNominal = trxNominalController.text;

    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.post(
        '$_apiUrl/tabungan',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'anggota_id': anggotaId,
          'trx_id': trxId,
          'trx_nominal': trxNominal,
        },
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Transaksi has been successfully added."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/transaksi'); // Close dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(context, "Failed to add transaction. Please try again.");
      }
    } on DioError catch (e) {
      setState(() {
        isLoading = false;
      });
      String errorMessage = 'Failed to add transaction. Please try again later.';
      if (e.response?.statusCode == 409) {
        errorMessage = 'Transaction already exists.';
      }
      showErrorDialog(context, errorMessage);
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
