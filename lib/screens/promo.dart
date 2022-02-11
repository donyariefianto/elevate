import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';

class Promo extends StatelessWidget {
  const Promo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mBackgroundColor,
      child: Center(
        // ignore: deprecated_member_use
        child: FlatButton(
          onPressed: () {},
          child: const Text('Go to next screen'),
          color: Colors.white,
        ),
      ),
    );
  }
}
