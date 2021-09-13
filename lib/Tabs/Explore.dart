import 'package:commutify/Provider/ProviderData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  Color a, b, c;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getColor();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderData>(context);
    return Scaffold(
      backgroundColor: a,
      body: ListView(
        children: [Text(provider.color)],
      ),
    );
  }

  // theme(String color) {
  //   if (color != null) {
  //     switch (color) {
  //       case 'a':
  //         a = Color(0xffff3985);
  //         b = Color(0xffff858d);
  //         c = Color(0xffff4f86);
  //         break;
  //       case 'b':
  //         a = Color(0xff3a506b);
  //         b = Color(0xff5bc0be);
  //         c = Color(0xff6fffe9);
  //         break;
  //     }
  //   }
  // }

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
          a = Color(0xff0b132b);
          b = Color(0xff5bc0be);
          c = Color(0xff3a506b);
        });
        break;
    }
  }
}
