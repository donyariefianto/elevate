import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:gym/screens/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const String sUrl = "https://apidony.000webhostapp.com/api/logout";
String token = "";
String id = "";

class _ProfilePageState extends State<ProfilePage> {
  @override
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
      prefs.remove('id');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: mBackgroundColor),
        ),
        actions: [
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Settings"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(
                          id: '',
                        )),
              );
            } else if (value == 1) {
              _logOut();
            }
          }),
        ],
        backgroundColor: mBlueColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<Member>>(
        future: fetchMember(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return Profile(member: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: mBlueColor,
              ),
            );
          }
        },
      ),
      // body: SafeArea(
      //   child: Container(
      //     color: Colors.white,
      //     child: Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: <Widget>[
      //           // Text(
      //           //   "Your Token : $token",
      //           //   style: TextStyle(fontSize: 20),
      //           // ),
      //           Stack(
      //             alignment: const Alignment(0.6, 0.6),
      //             children: [
      //               CircleAvatar(
      //                 backgroundImage: AssetImage('assets/Yellow.png'),
      //                 radius: 85,
      //               ),
      //               Container(
      //                 decoration: const BoxDecoration(
      //                   color: Colors.black45,
      //                 ),
      //                 child: const Text(
      //                   'Mia B',
      //                   style: TextStyle(
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.bold,
      //                     color: Colors.white,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),

      //           Column(
      //             children: [
      //               ListTile(
      //                 title: const Text(
      //                   '1625 Main Street',
      //                   style: TextStyle(fontWeight: FontWeight.w500),
      //                 ),
      //                 subtitle: const Text('My City, CA 99984'),
      //                 leading: Icon(
      //                   Icons.restaurant_menu,
      //                   color: Colors.orange[500],
      //                 ),
      //               ),
      //               ListTile(
      //                 title: const Text(
      //                   '(408) 555-1212',
      //                   style: TextStyle(fontWeight: FontWeight.w500),
      //                 ),
      //                 leading: Icon(
      //                   Icons.contact_phone,
      //                   color: Colors.orange[500],
      //                 ),
      //               ),
      //               ListTile(
      //                 title: const Text('costa@example.com'),
      //                 leading: Icon(
      //                   Icons.contact_mail,
      //                   color: Colors.orange[500],
      //                 ),
      //               ),
      //             ],
      //           ),
      //           SizedBox(
      //             height: 90,
      //           )
      //           // Container(
      //           //   padding:
      //           //       const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      //           //   child: InkWell(
      //           //     child: Container(
      //           //       width: MediaQuery.of(context).size.width,
      //           //       padding: const EdgeInsets.symmetric(vertical: 15),
      //           //       alignment: Alignment.center,
      //           //       decoration: BoxDecoration(
      //           //         borderRadius:
      //           //             const BorderRadius.all(Radius.circular(5)),
      //           //         boxShadow: <BoxShadow>[
      //           //           BoxShadow(
      //           //               color: Colors.grey.shade200,
      //           //               offset: const Offset(2, 4),
      //           //               blurRadius: 5,
      //           //               spreadRadius: 2)
      //           //         ],
      //           //         gradient: const LinearGradient(
      //           //           begin: Alignment.centerLeft,
      //           //           end: Alignment.centerRight,
      //           //           colors: [Color(0xff01579b), Color(0xff0d47a1)],
      //           //         ),
      //           //       ),
      //           //       child: const Text(
      //           //         'Logout',
      //           //         style: TextStyle(fontSize: 20, color: Colors.white),
      //           //       ),
      //           //     ),
      //           //     onTap: _logOut,
      //           //   ),
      //           // ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key, required this.member}) : super(key: key);
  final List<Member> member;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 24),
        itemCount: member.length,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/Yellow.png'),
                        radius: 75,
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.grey[200],
                  child: Center(
                    child: Card(
                      margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                      child: Container(
                        width: 310.0,
                        height: 290.0,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Information",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Divider(
                                color: Colors.grey[300],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.card_membership,
                                    color: Colors.blueAccent[400],
                                    size: 35,
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Status",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      (member[index].status == 1)
                                          ? Text(
                                              "Aktif",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          : Text("Nonaktif"),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.yellowAccent[400],
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Active time",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      Text(
                                        member[index].end,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey[400],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.perm_identity_outlined,
                                    color: Colors.pinkAccent[400],
                                    size: 35,
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ID MEMBER",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      Text(
                                        member[index].id,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey[400],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.data_usage_sharp,
                                    color: Colors.lightGreen[400],
                                    size: 35,
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Username",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      Text(
                                        member[index].nama,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey[400],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<List<Member>> fetchMember(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://apidony.000webhostapp.com/api/members/${id}'));
  return compute(parseMember, response.body);
}

List<Member> parseMember(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Member>((json) => Member.fromJson(json)).toList();
}

class Member {
  final String id;
  final String nama;
  final String telp;
  final String born;
  final String gender;
  final String start;
  final String end;
  final String join;
  final String tipe;
  final int status;

  const Member(
      {required this.id,
      required this.nama,
      required this.telp,
      required this.born,
      required this.gender,
      required this.start,
      required this.end,
      required this.join,
      required this.tipe,
      required this.status});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id_member'] as String,
      nama: json['username'] as String,
      telp: json['telp'] as String,
      born: json['tgl_lahir'] as String,
      gender: json['gender'] as String,
      start: json['start'] as String,
      end: json['end'] as String,
      join: json['tgl_join'] as String,
      tipe: json['nama_tipe'] as String,
      status: json['status'] as int,
    );
  }
}
