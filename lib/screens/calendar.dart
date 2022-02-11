import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
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

class Screen2 extends StatelessWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Text(
                'Screen 2',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              margin: const EdgeInsets.all(16),
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back'),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
