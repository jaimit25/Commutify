import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commutify/Provider/ProviderData.dart';
import 'package:commutify/Screens/Login.dart';
import 'package:commutify/Screens/Navigation.dart';
import 'package:commutify/style/colour.dart';
import 'package:commutify/style/decoration.dart';
import 'package:commutify/style/text.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

colour color = colour();
decoration deco = decoration();
text txt = text();

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String email;
  String password;
  String emailval;
  String uid;
  User user;
  String fuid;
  Color a;
  Color b;
  Color c;
  var colr;

  @override
  void initState() {
    super.initState();
    getColor();
    getData();
    Timer(Duration(seconds: 3), () {
      getData();

      directLogin();
    });
  }

  directLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    String password = prefs.getString('password');
    String uid = prefs.getString('uid');
    if (uid != null) {
      if (uid == fuid) {
        print(fuid);
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Navigation()));
      } else {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    } else {
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderData>(context);

    return Scaffold(
      backgroundColor: color.theme1,
      // body: Center(
      //   child: Container(
      //     height: 120,
      //     width: 120,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.all(Radius.circular(20)),
      //       image: DecorationImage(
      //         image: AssetImage('assets/images/gifupdated.gif'),
      //       ),
      //     ), // child: Text(provider.uid),
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/gifupdated.gif'),
                  ),
                ), // child: Text(provider.uid),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('Commutify',
                    textStyle: txt.andikawhitesplash),
                // ScaleAnimatedText(
                //   'Then Scale',
                //   textStyle:
                //       TextStyle(fontSize: 70.0, fontFamily: 'Canterbury'),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getData() async {
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxyyyyyyyyyyyyyyyyyyyyy");
    var user1 = FirebaseAuth.instance.currentUser;
    setState(() {
      user = user1;
      print(user1.uid);
      fuid = user.uid;
    });
    print(fuid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      password = prefs.getString('password');
      uid = prefs.getString('uid');
      colr = prefs.getString('color');
    });
  }

  getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String color = prefs.getString('color');
    print(color);
    switch (color) {
      case 'a':
        setState(() {
          a = Color(0xffff3985);
          b = Color(0xffff858d);
          c = Color(0xffff4f86);
        });
        break;
      case 'b':
        setState(() {
          a = Color(0xff3a506b);
          b = Color(0xff5bc0be);
          c = Color(0xff6fffe9);
        });
        break;
    }
  }
}
