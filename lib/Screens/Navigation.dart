import 'package:commutify/Tabs/Chat.dart';
import 'package:commutify/Tabs/Explore.dart';
import 'package:commutify/Tabs/Personal.dart';
import 'package:commutify/style/colour.dart';
import 'package:commutify/style/decoration.dart';
import 'package:commutify/style/text.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

colour color = colour();
decoration deco = decoration();
text txt = text();

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  Color a, b, c;

  var _currentindex = 0;
  final tabs = [
    Center(
      child: Explore(),
    ),
    Center(
      child: Chat(),
    ),
    Center(
      child: Personal(),
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getColor();
  }

  @override
  Widget build(BuildContext context) {
    onWillPop() {
      DialogBox(context);
    }

    return WillPopScope(
        child: Scaffold(
          // backgroundColor: color.theme2,
          backgroundColor: color.theme2,
          resizeToAvoidBottomInset: false,
          body: tabs[_currentindex],
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentindex,
            onTap: (index) {
              setState(() {
                _currentindex = index;
              });
            },
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: Icon(Icons.explore_outlined, color: Colors.white),
                title: Text("Explore", style: txt.lailaverysmall),
                selectedColor: b,
              ),

              /// Likes
              SalomonBottomBarItem(
                icon: Icon(Icons.chat_bubble_outline_rounded,
                    color: Colors.white),
                title: Text("chat", style: txt.lailaverysmall),
                selectedColor: b,
              ),

              /// Search
              SalomonBottomBarItem(
                icon: Icon(Icons.person, color: Colors.white),
                title: Text("Manage", style: txt.lailaverysmall),
                selectedColor: b,
              ),

              /// Profile
            ],
          ),

          // bottomNavigationBar: CurvedNavigationBar(
          //     backgroundColor: a,
          //     buttonBackgroundColor: c,
          //     color: b,
          //     items: [
          //       Icon(Icons.explore),
          //       Icon(Icons.chat_outlined),
          //       Icon(Icons.person),
          //     ],
          //     onTap: (index) {
          //       setState(() {
          //         _currentindex = index;
          //       });
          //     }),
        ),
        onWillPop: onWillPop);
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

void DialogBox(context) {
  var baseDialog = AlertDialog(
    title: new Text("Close the App"),
    // content: Container(
    //   color: Colors.black,
    //   height: 100,
    // ),
    actions: <Widget>[
      FlatButton(
        color: color.theme1,
        child: new Text("Exit App", style: txt.lailaverysmall),
        onPressed: () {
          SystemNavigator.pop();
        },
      ),
    ],
  );

  showDialog(context: context, builder: (BuildContext context) => baseDialog);
}
