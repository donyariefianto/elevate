import 'package:flutter/material.dart';
import 'package:gym/constants/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  // final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool visible = false;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String sUrl = "https://api.elevatekupang.com/public/api/";

  @override
  void initState() {
    super.initState();
  }

  _cekLogin() async {
    setState(() {
      visible = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var params = "login?username=" +
        userNameController.text +
        "&password=" +
        passwordController.text;
    try {
      var res = await http.post(Uri.parse(sUrl + params));
      // print(res.statusCode);
      if (res.statusCode == 200) {
        var response = json.decode(res.body);
        print(response['id']);
        print(res.statusCode);
        if (response['message'] != null) {
          prefs.setBool('slogin', true);
          prefs.setString('token', response['access_token']);
          prefs.setString('id', response['id']);
          setState(() {
            visible = false;
          });

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/landing', (Route<dynamic> route) => false);
        }
      } else {
        var response = json.decode(res.body);
        setState(() {
          visible = false;
        });
        print(response['message']);
        _showAlertDialog(context, response['message']);
      }
    } catch (e) {}
  }

  _showAlertDialog(BuildContext context, String err) {
    // ignore: deprecated_member_use
    Widget okButton = FlatButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Ok'),
    );
    AlertDialog alert = AlertDialog(
      title: const Text('Failed'),
      content: Text(err),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: const Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    // gradient: const LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [Color(0xff0d47a1), Color(0xff1e88e5)],
                    // ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                "assets/logo.png",
                                height: 130.0,
                                width: 300.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visible,
                        child: const CircularProgressIndicator(),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: userNameController,
                                  scrollPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: const InputDecoration(
                                    labelText: "Username",
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    hintText: "Username",
                                    border: InputBorder.none,
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Fill in the blank';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: passwordController,
                                  scrollPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      hoverColor: mBlueColor,
                                      hintText: "Password",
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      labelText: "Password",
                                      border: InputBorder.none,
                                      filled: true),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Fill in the blank';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
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
                              colors: [Color(0xff01579b), Color(0xff039be5)],
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        // onTap: _cekLogin,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _cekLogin();
                          }
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Dont have Acount?',
                          style: TextStyle(color: Colors.black54),
                        ),
                        onPressed: () {},
                      ),
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
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
  }
}
