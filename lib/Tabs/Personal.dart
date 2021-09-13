import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commutify/Model/UserProfile.dart';
import 'package:commutify/Provider/ProviderData.dart';
import 'package:commutify/style/colour.dart';
import 'package:commutify/style/decoration.dart';
import 'package:commutify/style/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

colour color = colour();
decoration deco = decoration();
text txt = text();

class Personal extends StatefulWidget {
  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  Color a, b, c;
  var uid;
  userprofile localuser;
  DocumentSnapshot doc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getColor();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderData>(context);

    return SafeArea(
        child: Scaffold(
      backgroundColor: a,
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('Users').doc(uid).get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return loadingwidget();
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: ListView(
                children: [
                  Container(
                    color: color.theme1,
                    padding: EdgeInsets.only(bottom: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          child: Container(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.edit_outlined,
                                  color: Colors.white, size: 30),
                            ),
                          ),
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(localuser.Photo),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              border: Border.all(color: Colors.white)),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Text(localuser.Name, style: txt.andikawhite),
                        ),
                      ],
                    ),
                  ),
                  Show(localuser.DOB, Icons.cake, color.theme1),
                  Divide(color.theme1),
                  Show(localuser.phone, Icons.phone_callback_outlined,
                      color.theme1),
                  Divide(color.theme1),
                  Show(localuser.aboutus, Icons.account_circle_rounded,
                      color.theme1),
                  Divide(color.theme1),
                  Show(localuser.Email, Icons.cake, color.theme1),
                  Builder(
                    builder: (BuildContext context) => GestureDetector(
                      onTap: () {
                        DialogBoxLogOut(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                                colors: [color.theme1, color.theme2])),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: 50,
                        child: Center(
                          child: Text(
                            'Logout',
                            style: txt.andikawhite,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    ));
  }

  void DialogBoxLogOut(context) {
    var baseDialog = AlertDialog(
      title: new Text("Sign Out ?"),
      content: Container(
        child: Text(
            'By Clicking On The yes Button You will Be Needed To Restart the App'),
      ),
      actions: <Widget>[
        FlatButton(
          color: color.theme1,
          child: new Text("Yes"),
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.clear();
            FirebaseAuth.instance.signOut();
            SystemNavigator.pop();
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  showSnackbar(context, String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        backgroundColor: color.theme1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        duration: Duration(milliseconds: 1000),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget BorderShape(Widget name) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: name,
      color: color.theme2,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.3),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }

  Widget SizedBoxShow() {
    return SizedBox(
      height: 20,
    );
  }

  Widget Divide(Color name) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Divider(color: name, thickness: 2),
    );
  }

  Widget Show(String name, var icon, Color color) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 4,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            Container(
              width: 200,
              margin: EdgeInsets.only(left: 20),
              child: Text(
                name,
                maxLines: 20,
                style: GoogleFonts.andika(
                  textStyle: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  func() async {}
  Widget loadingwidget() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    print(doc.data);
    setState(() {
      localuser = userprofile.fromDocument(doc);
    });
    print(localuser.Email);
  }

  getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    getData();
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
