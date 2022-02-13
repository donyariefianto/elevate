import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

String token = "";
String id = "";

class _PaymentState extends State<Payment> {
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
          'Payment',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<Payments>>(
        future: fetchPay(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return ListPay(pay: snapshot.data!);
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

class ListPay extends StatelessWidget {
  const ListPay({Key? key, required this.pay}) : super(key: key);
  final List<Payments> pay;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 24),
        itemCount: pay.length,
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
                              pay[index].nama_kelas.toString(),
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              pay[index].pm.toString() +
                                  ' ' +
                                  pay[index].tgl_jam.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green.shade300,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              pay[index].id_pembayaran.toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              child: Text(
                                pay[index].des.toString(),
                                maxLines: 4,
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

Future<List<Payments>> fetchPay(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://apidony.000webhostapp.com/api/payment/' + id));
  return compute(parsePayment, response.body);
}

List<Payments> parsePayment(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Payments>((json) => Payments.fromJson(json)).toList();
}

class Payments {
  final String? id_member;
  final String? nama;
  final String? tipe;
  final String? tgl_jam;
  final String? pm;
  final String? id_pembayaran;
  final int? harga;
  final int? total;
  final String? nama_kelas;
  final String? promo;
  final int? diskon;
  final String? des;

  const Payments({
    this.id_member,
    this.nama,
    this.tipe,
    this.tgl_jam,
    this.pm,
    this.id_pembayaran,
    this.harga,
    this.total,
    this.nama_kelas,
    this.promo,
    this.diskon,
    this.des,
  });

  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      id_member: json['id_member'] as String,
      nama: json['nama'] as String,
      tipe: json['tipe'] as String,
      tgl_jam: json['tgljam'] as String,
      pm: json['pm'] as String,
      id_pembayaran: json['id_pembayaran'] as String,
      harga: json['harga'] as int,
      total: json['total'] as int,
      nama_kelas: json['nama_kelas'] as String?,
      promo: json['promo'] as String,
      diskon: json['diskon'] as int,
      des: json['deskripsi'] as String,
    );
  }
}
