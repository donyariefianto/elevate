import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:gym/constants/style_constant.dart';
import 'package:http/http.dart' as http;

Future<List<Clastdy>> fetchClasstoday(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://apidony.000webhostapp.com/api/todayClass'));

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

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class'),
        backgroundColor: mBackgroundColor,
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
          Padding(
            padding: EdgeInsets.only(left: 20, top: 7, bottom: 12),
            child: Text(
              'Class Today !',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: mBlueColor),
            ),
          ),
          Container(
            height: 181,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 16),
              scrollDirection: Axis.horizontal,
              itemCount: clstd.length,
              itemBuilder: (context, index) {
                return Container(
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
                              image: const DecorationImage(
                                  image: NetworkImage(
                                      'https://app.elevatekupang.com/assets_user/images/promo/promo.jpg'),
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
                              '" ' + clstd[index].nama_kelas.toString() + ' "',
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
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 25),
            child: Text(
              'Popular',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: mBlueColor),
            ),
          ),
        ],
      ),
    );
  }
}
