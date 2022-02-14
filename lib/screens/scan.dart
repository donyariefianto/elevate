import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Products {
  int? id;
  String? name;
  String? description;
  String? price;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  Products(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.imageUrl,
      this.createdAt,
      this.updatedAt});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

String token = "";
String id = "";

class _Home extends State<Home> {
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

  List<Products> parsedata(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Products>((json) => Products.fromJson(json)).toList();
  }

  Future<List<Products>> fetchData(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://api.elevatekupang.com/public/api/products/'));
    return parsedata(response.body);
  }

  Future scans(http.Client client) async {
    String barcodeScanRes;
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    var params = '?id_memberr=${id}&id_jadwal=1&cin=${barcodeScanRes}';
    final response = await client
        .put(Uri.parse('https://apidony.000webhostapp.com/api/cin' + params));
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: ElevatedButton(
              onPressed: () => scans(http.Client()),
              child: const Text('Start barcode scan'),
            ),
          ),
        ),
      ),
    );
  }
}
