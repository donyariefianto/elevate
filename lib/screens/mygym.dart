import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'infocheklog.dart';

class MyGym extends StatefulWidget {
  const MyGym({Key? key}) : super(key: key);

  @override
  _MyGymState createState() => _MyGymState();
}

String token = "";
String id = "";

class _MyGymState extends State<MyGym> {
  void initState() {
    super.initState();
    load();
  }

  load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id')!;
      token = prefs.getString('token')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      body: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.class__rounded),
              title: Text('Gym'),
              subtitle: Text('Prescence'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  style: raisedButtonStylecin,
                  onPressed: () => cin(http.Client(), context),
                  child: Text('Check In'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: raisedButtonStylecout,
                  onPressed: () => cout(http.Client(), context),
                  child: Text('Check Out'),
                ),
                // TextButton(
                //   child: const Text('Chek In'),
                //   onPressed: () =>
                //       cin(http.Client(), listclas[index].id_kelas),
                // ),
                // const SizedBox(width: 8),
                // Icon(Icons.check_outlined),
                // TextButton(
                //   child: const Text('Chek Out'),
                //   onPressed: () =>
                //       cout(http.Client(), listclas[index].id_kelas),
                // ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future cout(http.Client client, BuildContext context) async {
  String barcodeScanRes;
  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
  var params = '?id_memberr=${id}&id_jadwal=0';
  final response = await client.post(Uri.parse(barcodeScanRes + params));
  // print(response.statusCode);
  // print(response.body);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Classclg()),
  );
}

Future cin(http.Client client, BuildContext context) async {
  String barcodeScanRes;
  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
  var params = '?id_memberr=${id}&id_jadwal=0';
  final response = await client.post(Uri.parse(barcodeScanRes + params));
  // print(response.statusCode);
  // print(response.body);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Classclg()),
  );
}

final ButtonStyle raisedButtonStylecin = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.lightGreen,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(6)),
  ),
);
final ButtonStyle raisedButtonStylecout = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.redAccent,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(6)),
  ),
);
