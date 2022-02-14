import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Classinf extends StatefulWidget {
  const Classinf({Key? key}) : super(key: key);

  @override
  _ClassinfState createState() => _ClassinfState();
}

String token = "";
String id = "";

class _ClassinfState extends State<Classinf> {
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
          'Class Information',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<Classinftion>>(
        future: fetchClassinf(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return ListClassinf(deskripsit: snapshot.data!);
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

class ListClassinf extends StatelessWidget {
  const ListClassinf({Key? key, required this.deskripsit}) : super(key: key);
  final List<Classinftion> deskripsit;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 24),
        itemCount: deskripsit.length,
        itemBuilder: (context, index) {
          return Center(
            child: Card(
              child: Container(
                margin:
                    EdgeInsets.only(top: 32, left: 18, right: 18, bottom: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      // backgroundImage: NetworkImage(
                      //     'https://app.elevatekupang.com/assets_user/images/deskripsi/' +
                      //         deskripsit[index].nama_kelas),
                      radius: 48,
                      backgroundColor: Colors.lightBlue,
                      child: Text(
                        deskripsit[index].nama_kelas.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              deskripsit[index].deskripsi.toString(),
                              maxLines: 3,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              child: Text('Kapasitas  ' +
                                  deskripsit[index].kapasitas.toString()),
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

Future<List<Classinftion>> fetchClassinf(http.Client client) async {
  final response =
      await client.get(Uri.parse('https://apidony.000webhostapp.com/api/pop'));
  return compute(parseClassinf, response.body);
}

List<Classinftion> parseClassinf(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Classinftion>((json) => Classinftion.fromJson(json))
      .toList();
}

class Classinftion {
  final int id;
  final String nama_kelas;
  final int kapasitas;
  final String deskripsi;

  const Classinftion({
    required this.id,
    required this.nama_kelas,
    required this.kapasitas,
    required this.deskripsi,
  });

  factory Classinftion.fromJson(Map<String, dynamic> json) {
    return Classinftion(
      id: json['id'] as int,
      nama_kelas: json['nama_kelas'] as String,
      kapasitas: json['kapasitas'] as int,
      deskripsi: json['deskripsi'] as String,
    );
  }
}
