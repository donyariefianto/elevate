import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'infocheklog.dart';

class Myclass extends StatefulWidget {
  const Myclass({Key? key}) : super(key: key);

  @override
  _MyclassState createState() => _MyclassState();
}

String token = "";
String id = "";

class _MyclassState extends State<Myclass> {
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
      body: FutureBuilder<List<Kelas>>(
        future: fetchClas(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return ListClas(listclas: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: mBlueColor,
              ),
            );
          }
        },
      ),
    );
  }
}

class ListClas extends StatelessWidget {
  const ListClas({Key? key, required this.listclas}) : super(key: key);
  final List<Kelas> listclas;

  Future cout(http.Client client, int ids, BuildContext context) async {
    String barcodeScanRes;
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    var params = '?id_memberr=${id}&id_jadwal=${ids}';
    final response = await client.post(Uri.parse(barcodeScanRes + params));
    // print(response.statusCode);
    // print(response.body);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Classclg()),
    );
  }

  Future cin(http.Client client, int ids, BuildContext context) async {
    String barcodeScanRes;
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    var params = '?id_memberr=${id}&id_jadwal=${ids}';
    final response = await client.post(Uri.parse(barcodeScanRes + params));
    // print(response.statusCode);
    // print(response.body);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Classclg()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: listclas.length,
        itemBuilder: (context, index) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.class__rounded),
                        title: Text(listclas[index].nama_kelas.toString()),
                        subtitle: Text(
                          listclas[index].deskripsi.toString(),
                          maxLines: 3,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            style: raisedButtonStylecin,
                            onPressed: () => cin(http.Client(),
                                listclas[index].id_kelas, context),
                            child: Text('Check In'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: raisedButtonStylecout,
                            onPressed: () => cout(http.Client(),
                                listclas[index].id_kelas, context),
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
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<List<Kelas>> fetchClas(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://apidony.000webhostapp.com/api/myclass/$id'));

  // Use the compute function to run parselistclas in a separate isolate.
  return compute(parseClass, response.body);
}

List<Kelas> parseClass(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  // print(responseBody);
  return parsed.map<Kelas>((json) => Kelas.fromJson(json)).toList();
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

class Kelas {
  final String hari;
  final String jam;
  final String jam_end;
  final int id_kelas;
  final String nama_kelas;
  final String deskripsi;
  final int kapasitas;
  final String id_member;

  const Kelas({
    required this.hari,
    required this.jam,
    required this.jam_end,
    required this.id_kelas,
    required this.nama_kelas,
    required this.deskripsi,
    required this.kapasitas,
    required this.id_member,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      hari: json['hari'] as String,
      jam: json['jam'] as String,
      jam_end: json['jam_end'] as String,
      id_kelas: json['id'] as int,
      nama_kelas: json['nama_kelas'] as String,
      deskripsi: json['deskripsi'] as String,
      kapasitas: json['kapasitas'] as int,
      id_member: json['id_member'] as String,
    );
  }
}
