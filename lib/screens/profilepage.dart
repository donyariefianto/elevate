import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const String sUrl = "https://apidony.000webhostapp.com/api/logout";
String token = "";

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
    });
  }

  _logOut() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      var res = await http.post(Uri.parse(sUrl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print(res.statusCode);
      prefs.setBool('slogin', false);
      prefs.remove('token');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: mBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text(
                //   "Your Token : $token",
                //   style: TextStyle(fontSize: 20),
                // ),
                Stack(
                  // alignment: const Alignment(0.6, 0.6),
                  children: const [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/Yellow.png'),
                      radius: 85,
                    ),
                    // Container(
                    //   decoration: const BoxDecoration(
                    //     color: Colors.black45,
                    //   ),
                    //   child: const Text(
                    //     'Mia B',
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),

                Column(
                  children: [
                    ListTile(
                      title: const Text(
                        '1625 Main Street',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: const Text('My City, CA 99984'),
                      leading: Icon(
                        Icons.restaurant_menu,
                        color: Colors.orange[500],
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        '(408) 555-1212',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      leading: Icon(
                        Icons.contact_phone,
                        color: Colors.orange[500],
                      ),
                    ),
                    ListTile(
                      title: const Text('costa@example.com'),
                      leading: Icon(
                        Icons.contact_mail,
                        color: Colors.orange[500],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.shade200,
                              offset: const Offset(2, 4),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xff01579b), Color(0xff0d47a1)],
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    onTap: _logOut,
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
