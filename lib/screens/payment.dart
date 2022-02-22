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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(todo: pay[index]),
                  ),
                );
              },
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
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  pay[index].id_pembayaran.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5, left: 10),
                                child: Text(
                                  pay[index].tgl_jam.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 5, left: 10),
                                  child: Text(pay[index].pm.toString())),
                              Container(
                                padding: EdgeInsets.only(top: 5, left: 10),
                                child: Text(
                                  'Rp. ' + pay[index].hrg.toString(),
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
            ),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.todo}) : super(key: key);

  final Payments todo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Payments',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: Container(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      todo.id_pembayaran.toString(),
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      todo.tgl_jam.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 5, left: 10),
                      child: Text(todo.pm.toString())),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<Payments>> fetchPay(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://api.elevatekupang.com/public/api/payment/' + id));

  return compute(parsePayment, response.body);
}

List<Payments> parsePayment(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Payments>((json) => Payments.fromJson(json)).toList();
}

class Payments {
  final String? nama;
  final String? tgl_jam;
  final String? pm;
  final String? id_pembayaran;
  final String? kelas;
  final String? total;
  final String? hrg;

  const Payments(
      {this.nama,
      this.tgl_jam,
      this.pm,
      this.id_pembayaran,
      this.kelas,
      this.total,
      this.hrg});

  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      nama: json['nama'] as String,
      tgl_jam: json['tgljam'] as String,
      pm: json['pm'] as String,
      id_pembayaran: json['id_pembayaran'] as String,
      total: json['grand_total'] as String,
      kelas: json['kelas'] as String,
      hrg: json['harga'] as String,
    );
  }
}
