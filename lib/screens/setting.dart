import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';

class Settings extends StatelessWidget {
  Settings({Key? key, this.product, required this.id}) : super(key: key);
  final dynamic product;
  final String id;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _cname = TextEditingController();
  final TextEditingController _cimg = TextEditingController();
  final TextEditingController _cdesc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      // body: Container(
      //   // alignment: Alignment.center,
      //   padding: const EdgeInsets.all(8.0),
      //   child: Card(
      //     child: Padding(
      //       padding: const EdgeInsets.all(12.0),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: <Widget>[
      //           TextField(
      //             controller: _cname,
      //             decoration: const InputDecoration(hintText: 'Enter name'),
      //           ),
      //           TextField(
      //             controller: _cdesc,
      //             decoration:
      //                 const InputDecoration(hintText: 'Enter description'),
      //           ),
      //           TextField(
      //             controller: _cimg,
      //             decoration: const InputDecoration(hintText: 'Enter img'),
      //           ),
      //           TextField(
      //             controller: _controller,
      //             decoration: const InputDecoration(hintText: 'Enter price'),
      //           ),
      //           ElevatedButton(
      //             onPressed: () {
      //               // Product product = Product(
      //               //   name: _cname.text,
      //               //   price: _controller.text,
      //               //   img: _cimg.text,
      //               //   description: _cdesc.text,
      //               // );
      //               // update(id.toString(), product);
      //               // print(id);
      //               // Navigator.push(
      //               //   context,
      //               //   MaterialPageRoute(
      //               //     builder: (context) => MyApp(),
      //               //   ),
      //               // );
      //             },
      //             child: const Text('Update Data'),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

// Future<Product> update(String id, Product product) async {
//   // final response = await http.post(Uri.parse(url), body: product.toJson());
//   final response = await http.put(Uri.parse(url + id), body: product.toJson());

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Product.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to update album.');
//   }
// }
