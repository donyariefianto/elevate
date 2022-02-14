import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

String token = "";
String id = "";

class _AttendanceState extends State<Attendance> {
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
      body: FutureBuilder<List<Attendd>>(
        future: fetchAttend(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return ListAttend(attend: snapshot.data!);
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

class ListAttend extends StatelessWidget {
  const ListAttend({Key? key, required this.attend}) : super(key: key);
  final List<Attendd> attend;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 24),
        itemCount: attend.length,
        itemBuilder: (context, index) {
          return Center(
            child: Card(
              child: Container(
                margin:
                    EdgeInsets.only(top: 32, left: 18, right: 18, bottom: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              attend[index].nama_kelas.toString(),
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              attend[index].hari.toString() +
                                  ' ' +
                                  attend[index].jam,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green.shade300,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              child: Text(
                                attend[index].deskripsi.toString(),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<List<Attendd>> fetchAttend(http.Client client) async {
  final response =
      await client.get(Uri.parse('https://api.elevatekupang.com/public/' + id));
  return compute(parseatt, response.body);
}

List<Attendd> parseatt(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Attendd>((json) => Attendd.fromJson(json)).toList();
}

class Attendd {
  final String deskripsi;
  final int kapasitas;
  final String nama_kelas;
  final String jam;
  final String jam_end;
  final String hari;
  final String cin;
  final String cout;
  final String nama;

  const Attendd({
    required this.deskripsi,
    required this.kapasitas,
    required this.nama_kelas,
    required this.jam,
    required this.jam_end,
    required this.hari,
    required this.cin,
    required this.cout,
    required this.nama,
  });

  factory Attendd.fromJson(Map<String, dynamic> json) {
    return Attendd(
      deskripsi: json['deskripsi'] as String,
      kapasitas: json['kapasitas'] as int,
      nama_kelas: json['nama_kelas'] as String,
      jam: json['jam'] as String,
      jam_end: json['jam_end'] as String,
      hari: json['hari'] as String,
      cin: json['cin'] as String,
      cout: json['cout'] as String,
      nama: json['nama'] as String,
    );
  }
}
