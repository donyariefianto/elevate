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
                      backgroundColor: Colors.blue.shade900,
                      child: Text(
                        deskripsit[index].nama_kelas.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(todo: deskripsit[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                deskripsit[index].nama_kelas.toString(),
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                deskripsit[index].deskripsi.toString(),
                                maxLines: 3,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
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

class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  final Classinftion todo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          todo.nama_kelas,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(todo.deskripsi),
          ],
        ),
      ),
    );
  }
}

Future<List<Classinftion>> fetchClassinf(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://api.elevatekupang.com/public/api/pop'));
  print(response.body);
  return compute(parseClassinf, response.body);
}

List<Classinftion> parseClassinf(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Classinftion>((json) => Classinftion.fromJson(json))
      .toList();
}

class Classinftion {
  final String? id;
  final String nama_kelas;
  final String? kapasitas;
  final String deskripsi;

  const Classinftion({
    required this.id,
    required this.nama_kelas,
    required this.kapasitas,
    required this.deskripsi,
  });

  factory Classinftion.fromJson(Map<String, dynamic> json) {
    return Classinftion(
      id: json['id'],
      nama_kelas: json['nama_kelas'] as String,
      kapasitas: json['kapasitas'] as String,
      deskripsi: json['deskripsi'] as String,
    );
  }
}
