import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Classclg extends StatefulWidget {
  const Classclg({Key? key}) : super(key: key);

  @override
  _ClassclgState createState() => _ClassclgState();
}

String token = "";
String id = "";

class _ClassclgState extends State<Classclg> {
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
          'Chek Log',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<Classclgtion>>(
        future: fetchClassclg(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return ListClassclg(jadwal: snapshot.data!);
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

int a = 10;

class ListClassclg extends StatelessWidget {
  const ListClassclg({Key? key, required this.jadwal}) : super(key: key);
  final List<Classclgtion> jadwal;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 24),
        itemCount: jadwal.length,
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
                      //     'https://app.elevatekupang.com/assets_user/images/id_jadwal/' +
                      //         jadwalt[index].id_member),
                      radius: 48,
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        "Attendance",
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
                            Container(
                              child: Text(''),
                            ),
                            Container(
                              child: Row(children: [
                                if (jadwal[index].cin ==
                                    "0000-00-00 00:00:00") ...[
                                  const Text(
                                    'Out',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ] else if (jadwal[index].cout ==
                                    "0000-00-00 00:00:00") ...[
                                  const Text(
                                    'Out',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              child: Text(
                                'In  ' + jadwal[index].cin.toString(),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              child: Text(
                                'Out  ' + jadwal[index].cout.toString(),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
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

Future<List<Classclgtion>> fetchClassclg(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://apidony.000webhostapp.com/api/ceklog/${id}'));
  print(response.body);
  return compute(parseClassclg, response.body);
}

List<Classclgtion> parseClassclg(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Classclgtion>((json) => Classclgtion.fromJson(json))
      .toList();
}

class Classclgtion {
  final int id;
  final String? cin;
  final String? cout;

  const Classclgtion({
    required this.id,
    this.cin,
    this.cout,
  });

  factory Classclgtion.fromJson(Map<String, dynamic> json) {
    return Classclgtion(
      id: json['id'] as int,
      cin: json['cin'] as String,
      cout: json['cout'] as String,
    );
  }
}
