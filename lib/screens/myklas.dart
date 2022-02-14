import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:gym/constants/style_constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class kelass extends StatefulWidget {
  const kelass({Key? key}) : super(key: key);

  @override
  _kelassState createState() => _kelassState();
}

String token = "";
String id = "";

class _kelassState extends State<kelass> {
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
          'My Class',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<Clastdy>>(
        future: fetchClasstoday(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('No Connection'),
            );
          } else if (snapshot.hasData) {
            return Clstd(clstd: snapshot.data!);
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

class Clstd extends StatelessWidget {
  final List<Clastdy> clstd;

  const Clstd({Key? key, required this.clstd}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 12, bottom: 12),
            child: Text(
              'Class',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: mBlueColor),
            ),
          ),
          Container(
            height: 700,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 16),
              scrollDirection: Axis.vertical,
              itemCount: clstd.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(todo: clstd[index]),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 104,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: AssetImage('assets/logo.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              child: SvgPicture.asset(
                                  'assets/svg/travlog_top_corner.svg'),
                              right: 0,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Text(
                                clstd[index].hari.toString(),
                                style: mTravlogTitleStyle,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: SvgPicture.asset(
                                  'assets/svg/travlog_bottom_gradient.svg'),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Text(
                                '" ' +
                                    clstd[index].nama_kelas.toString() +
                                    ' "',
                                style: mTravlogTitleStyle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          clstd[index].deskripsi.toString(),
                          maxLines: 3,
                          style: mTravlogContentStyle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'At ' +
                              clstd[index].jam.toString() +
                              ' - ' +
                              clstd[index].jam_end.toString(),
                          style: mTravlogPlaceStyle,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  final Clastdy todo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          todo.nama_kelas.toString(),
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
            Text(todo.deskripsi.toString()),
          ],
        ),
      ),
    );
  }
}

Future<List<Clastdy>> fetchClasstoday(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://api.elevatekupang.com/public/api/myclass/' + id));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseClstd, response.body);
}

List<Clastdy> parseClstd(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(responseBody);
  return parsed.map<Clastdy>((json) => Clastdy.fromJson(json)).toList();
}

class Clastdy {
  final String? hari, jam, jam_end, nama_kelas, deskripsi;

  const Clastdy(
      {this.hari, this.jam, this.jam_end, this.nama_kelas, this.deskripsi});

  factory Clastdy.fromJson(Map<String, dynamic> json) {
    return Clastdy(
      hari: json['hari'] as String,
      jam: json['jam'] as String,
      jam_end: json['jam_end'] as String,
      nama_kelas: json['nama_kelas'] as String,
      deskripsi: json['deskripsi'] as String,
    );
  }
}
