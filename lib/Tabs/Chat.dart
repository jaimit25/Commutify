import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commutify/Provider/ProviderData.dart';
import 'package:commutify/pages/ChatList.dart';
import 'package:commutify/pages/Search.dart';
import 'package:commutify/style/colour.dart';
import 'package:commutify/style/decoration.dart';
import 'package:commutify/style/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

colour color = colour();
decoration deco = decoration();
text txt = text();

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Color a, b, c;
  String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getColor();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderData>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: color.theme1,
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4.0,
              physics: BouncingScrollPhysics(),
              tabs: [
                Tab(
                    child: Text(
                  'Search',
                  style: txt.andikawhitesmall,
                )),
                Tab(
                    child: Text(
                  'ChatList',
                  style: txt.andikawhitesmall,
                )),
              ],
            ),
            title: Text(
              'Commutify',
              style: txt.andikawhite,
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Search(),
              ),
              Center(
                child: ChatList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String color = prefs.getString('color');
    uid = prefs.getString('uid');

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
          a = Color(0xff0b132b);
          b = Color(0xff5bc0be);
          c = Color(0xff3a506b);
        });
        break;
    }
  }
}
