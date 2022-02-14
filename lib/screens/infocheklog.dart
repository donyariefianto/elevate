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

String a = '0000-00-00 00:00:00';

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
                    EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (jadwal[index].cin == a)
                      const CircleAvatar(
                        // backgroundImage: NetworkImage(
                        //     'https://app.elevatekupang.com/assets_user/images/id_jadwal/' +
                        //         jadwalt[index].id_member),
                        radius: 32,
                        backgroundColor: Colors.blueGrey,
                        child: Text(
                          "OUT",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (jadwal[index].cout == a)
                      const CircleAvatar(
                        // backgroundImage: NetworkImage(
                        //     'https://app.elevatekupang.com/assets_user/images/id_jadwal/' +
                        //         jadwalt[index].id_member),
                        radius: 32,
                        backgroundColor: Colors.blueGrey,
                        child: Text(
                          "IN",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(2),
                        padding: EdgeInsets.only(left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                                child: jadwal[index].cin == a
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            jadwal[index].kelas.toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            jadwal[index].cout.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            jadwal[index].kelas.toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            jadwal[index].cin.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      )),
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
      .get(Uri.parse('https://api.elevatekupang.com/public/api/ceklog/${id}'));
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
  // final String id;
  final String? cin;
  final String? cout;
  final String? kelas;

  const Classclgtion({
    // required this.id,
    this.cin,
    this.cout,
    this.kelas,
  });

  factory Classclgtion.fromJson(Map<String, dynamic> json) {
    return Classclgtion(
      // id: json['id'] as String,
      cin: json['cin'] as String,
      cout: json['cout'] as String,
      kelas: json['kelas'] as String,
    );
  }
}
