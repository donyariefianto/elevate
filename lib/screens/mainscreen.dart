import 'package:gym/constants/color_constant.dart';
import 'package:gym/screens/payment.dart';
import 'package:gym/screens/promo.dart';
import 'package:gym/screens/schedule.dart';
import 'package:gym/screens/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:gym/screens/tes.dart';
import 'package:gym/screens/tes2.dart';

import 'myklas.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const MyHomePage(
      title: '',
    ),
    kelass(),
    const Promo(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: ('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.class__outlined),
              label: ('My Class'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              label: ('Promotion'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: ('Profile'),
            ),
          ],
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          // backgroundColor: Colors.tra,
          selectedItemColor: mBlueColor,
          unselectedItemColor: Colors.grey.shade500,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
