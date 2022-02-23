import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Promo extends StatefulWidget {
  const Promo({Key? key}) : super(key: key);

  @override
  _PromoState createState() => _PromoState();
}

String token = "";
String id = "";

class _PromoState extends State<Promo> {
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
          'Promo',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<Promotion>>(
        future: fetchPromo(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return ListPromo(promot: snapshot.data!);
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

class ListPromo extends StatelessWidget {
  const ListPromo({Key? key, required this.promot}) : super(key: key);
  final List<Promotion> promot;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 24),
        itemCount: promot.length,
        itemBuilder: (context, index) {
          return Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(todo: promot[index]),
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
                      CircleAvatar(
                        //backgroundImage: NetworkImage(
                        // 'https://app.elevatekupang.com/assets_user/images/promo/' +
                        //      promot[index].gambar),
                        radius: 48,
                        backgroundColor: Colors.blue.shade900,
                        child: Text(
                          promot[index].diskon.toString() + ' %',
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
                                promot[index].promo.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 12),
                                child: Text(
                                    'Exp. ' + promot[index].exp.toString()),
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
  // In the constructor, require a Todo.
  const DetailScreen({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  final Promotion todo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          todo.promo,
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
        child: Card(
          child: Container(
            padding: EdgeInsets.all(25),
            width: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    todo.promo,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    'Expired ' + todo.exp,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.local_offer_outlined),
                    SizedBox(height: 50),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        todo.diskon + ' %',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    'Deskripsi ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<Promotion>> fetchPromo(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://api.elevatekupang.com/public/api/promo'));
  return compute(parsePromo, response.body);
}

List<Promotion> parsePromo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Promotion>((json) => Promotion.fromJson(json)).toList();
}

class Promotion {
  final int id;
  final String gambar;
  final String exp;
  final String diskon;
  final String promo;

  const Promotion({
    required this.id,
    required this.gambar,
    required this.exp,
    required this.diskon,
    required this.promo,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as int,
      gambar: json['gambar'] as String,
      exp: json['exp_promo'] as String,
      diskon: json['diskon'] as String,
      promo: json['promo'] as String,
    );
  }
}
