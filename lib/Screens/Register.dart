import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commutify/Provider/ProviderData.dart';
import 'package:commutify/Screens/Navigation.dart';
import 'package:commutify/style/colour.dart';
import 'package:commutify/style/decoration.dart';
import 'package:commutify/style/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

colour color = colour();
decoration deco = decoration();
text txt = text();

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  var dateee, dOB;
  DateTime currentDate = DateTime.now();
  String date = '222';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2030));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        date = pickedDate.toString()[0] +
            pickedDate.toString()[1] +
            pickedDate.toString()[2] +
            pickedDate.toString()[3];
        dOB = pickedDate.day.toString() +
            "-" +
            pickedDate.month.toString() +
            "-" +
            pickedDate.year.toString();

        var intdate = int.parse(date);
        assert(intdate is int);
        print(intdate);
        print(dOB);

        setState(() {
          dateee = intdate;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderData>(context);
    onWillPop() {
      Navigator.of(context).pop();
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: formstate,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Register',
                    style: txt.lailared,
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        scale: 1.0,
                        image: AssetImage('assets/images/loginbck.png'),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: color.themeA, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextFormField(
                    style: TextStyle(),
                    controller: _nameController,
                    decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.person, color: Color(0xffFF4F86)),
                        hintText: 'Enter Your Name',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        border: InputBorder.none),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: color.themeA, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextFormField(
                    style: TextStyle(),
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Color(0xffFF4F86)),
                        hintText: 'Enter Your Email Id',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        border: InputBorder.none),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: color.themeA, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextFormField(
                    style: TextStyle(),
                    controller: _passController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.security_rounded,
                            color: Color(0xffFF4F86)),
                        hintText: 'Enter Your Password ...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        border: InputBorder.none),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: Icon(
                      Icons.cake_rounded,
                      color: color.themeA,
                      size: 30,
                    ),
                  ),
                  Text(
                    dOB == null ? "Select date" : dOB,
                    style: txt.andikasmall,
                  )
                ]),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: color.themeA,
                    thickness: 2,
                  ),
                ),
                Container(
                  height: 45,
                  decoration: deco.radius,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: MaterialButton(
                    color: color.themeA,
                    onPressed: () async {
                      if (dOB != null &&
                          _emailController.text != null &&
                          _passController != null) {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passController.text)
                            .then((value) async {
                          User user = value.user;
                          print(_nameController.text);

                          print('you clicked login');
                          if (user.uid != null) {
                            await FirebaseFirestore.instance
                                .collection('/Users')
                                .doc(user.uid)
                                .set({
                              'uid': user.uid,
                              'DOB': dOB,
                              'Name': _nameController.text,
                              'Email': _emailController.text,
                              'phone': 'Number',
                              'aboutus':
                                  '\"You Know Yourself better\"...Tell About Yourself',
                              'Photo':
                                  'https://cactusthemes.com/blog/wp-content/uploads/2018/01/tt_avatar_small.jpg',
                              'Date': dateee,
                              'searchName': _nameController.text.toLowerCase(),
                              "caseSearch": setSearchParam(
                                  _nameController.text.toLowerCase()),
                            }).then((result) {
                              print("User Added");
                              provider.setemail(_emailController.text);
                              provider.setpassword(_passController.text);
                              provider.setuid(user.uid);
                            }).catchError((e) {
                              print("Error: $e" + "!");
                            });
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Navigation()));
                          } else {
                            DialogBox(context);
                          }
                        }).catchError((e) {
                          DialogBox(context);
                        });
                      } else {
                        DialogBox2(context);
                      }
                    },
                    child: Text(
                      'Login',
                      style: txt.lailawhite,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: color.themeA,
                    thickness: 2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Container(
                      child: Text(
                        'Already Have An Account? Login',
                        style: txt.andikasmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: onWillPop);
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  void DialogBox(context) {
    var baseDialog = AlertDialog(
      title: new Text("Login Failed"),
      content: Container(
        child:
            Text('Please try Again After Sometime or Enter Valid Credentials'),
      ),
      actions: <Widget>[
        FlatButton(
          color: color.themeA,
          child: new Text("Back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  void DialogBox2(context) {
    var baseDialog = AlertDialog(
      title: new Text("Warning"),
      content: Container(
        child: Text('Enter All The Fields'),
      ),
      actions: <Widget>[
        FlatButton(
          color: color.themeA,
          child: new Text("Back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }
}
