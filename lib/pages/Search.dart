import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commutify/Provider/ProviderData.dart';
import 'package:commutify/Screens/ChatScreen.dart';
import 'package:commutify/Screens/Navigation.dart';
import 'package:commutify/style/colour.dart';
import 'package:commutify/style/decoration.dart';
import 'package:commutify/style/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

colour color = colour();
decoration deco = decoration();
text txt = text();

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  var searchsnapshot;
  QuerySnapshot searchResultSnapshot;
  TextEditingController searchEditingController = new TextEditingController();
  bool isLoading = false;
  bool haveUserSearched = false;
  var Data;
  String uiduser;

  Color a, b, c;
  @override
  void initState() {
    super.initState();
    getColor();
    getDataShared();
    Data = FirebaseFirestore.instance.collection('Users').snapshots();
  }

  getDataShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uiduser = prefs.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderData>(context);
    onWillPop() {}
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: color.theme3,
          appBar: AppBar(
            backgroundColor: color.theme1,
            title: Container(
              height: 40,
              margin: EdgeInsets.only(top: 10, bottom: 8, right: 12, left: 12),
              padding: EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 7),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextFormField(
                style: TextStyle(),

                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) {
                  // Fluttertoast.showToast(
                  //     msg: "This is Center Short Toast",
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.CENTER,
                  //     timeInSecForIosWeb: 1,
                  //     backgroundColor: Colors.red,
                  //     textColor: Colors.white,
                  //     fontSize: 16.0);

                  setState(() {
                    haveUserSearched = !haveUserSearched;
                  });
                },
                // controller: _searchController,
                controller: _searchController,
                onChanged: (query) {
                  // searchUser(query);
                  setState(() {
                    haveUserSearched = !haveUserSearched;
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: color.theme1),
                    hintText: 'Search ...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          body: userList(),
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
          a = Color(0xff0b132b);
          b = Color(0xff5bc0be);
          c = Color(0xff3a506b);
        });
        break;
    }
  }

  String getRoomId(String uid, String fuid) {
    String a = uid;
    String b = fuid;
    if (a.codeUnitAt(0) == b.codeUnitAt(0)) {
      for (int i = 0; i <= 8; i++) {
        if (a.codeUnitAt(i) != b.codeUnitAt(i)) {
          if (a.codeUnitAt(i) > b.codeUnitAt(i)) {
            return a + b;
          } else {
            return b + a;
          }
        }
      }
    }
//   else {
    if (a.codeUnitAt(0) > b.codeUnitAt(0)) {
      return a + b;
    } else {
      return b + a;
    }
//   }
  }

  // initiateSearch() async {
  //   if (searchEditingController.text.isNotEmpty) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await FirebaseFirestore.instance
  //         .collection("Users")
  //         .where('searchName', isEqualTo: _searchController.text)
  //         .get()
  //         .then((snapshot) {
  //       setState(() {
  //         searchResultSnapshot = snapshot;
  //       });
  //       print("$searchResultSnapshot");
  //       setState(() {
  //         isLoading = false;
  //         print('xxnaxjnajnjaxnjanjaxnajxnjanxjan');
  //         haveUserSearched = true;
  //       });
  //     });
  //   }
  // }

  Widget userList() {
    return haveUserSearched
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .where('searchName',
                    isGreaterThanOrEqualTo:
                        _searchController.text.toLowerCase())
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data.docs.map<Widget>((document) {
                  // return Text(document['UserName']);
                  return userTile(document['Name'], document['Email'],
                      document['Photo'], document['uid'], document.id);
                }).toList(),
              );
            },
          )
        : Center(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("UserSearched")
                  .where('uiduser', isEqualTo: uiduser)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: snapshot.data.docs.map<Widget>((document) {
                    // return Text(document['UserName']);
                    return userTileDelete(document['Name'], document['Email'],
                        document['Photo'], document['uuid'], document.id);
                  }).toList(),
                );
              },
            ),
          );
  }

  Widget userTileDelete(
      String userName, String userEmail, String Photo, String uuid, String id) {
    return MaterialButton(
      onPressed: () {},
      hoverColor: color.theme1,
      child: Container(
          child: Column(
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                //              SharedPreferences prefs = await SharedPreferences.getInstance();
                // uiduser = prefs.getString('uid');
                // sendMessage(userName);
                FirebaseFirestore.instance
                    .collection('UserSearched')
                    .doc(userName + uiduser)
                    .set({
                  'Name': userName,
                  'Photo': Photo,
                  'Email': userEmail,
                  'uuid': uuid,
                  'uiduser': uiduser
                }).then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String saveuid = prefs.getString('uid');
                  String createRoom = getRoomId(saveuid, uuid);

                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          roomId: createRoom,
                          uuid: uuid,
                          Name: userName,
                          Photo: Photo,
                          Email: userEmail),
                    ),
                  );
                });
                // .then((value) async {
                //   SharedPreferences prefs = await SharedPreferences.getInstance();
                //   String saveuid = prefs.getString('uid');
                //   String createRoom = getRoomId(saveuid, uuid);
                //   FirebaseFirestore.instance
                //       .collection('chatRoom')
                //       .doc(createRoom)
                //       .set({
                //     'Name': userName,
                //     'Photo': Photo,
                //     'Email': userEmail,
                //     'uuid': uuid,
                //     'uid': uiduser,
                //     'roomId': createRoom,
                //     'lastMessage': '...',
                //     'check': false
                //   }).then((value) {
                //     Fluttertoast.showToast(
                //         msg: "Room Created",
                //         toastLength: Toast.LENGTH_SHORT,
                //         gravity: ToastGravity.CENTER,
                //         timeInSecForIosWeb: 1,
                //         backgroundColor: Colors.red,
                //         textColor: Colors.white,
                //         fontSize: 16.0);
                //   });
                // });
              },
              child: Container(
                // color: Colors.pink,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  // color: Colors.pink
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(width: 3, color: Colors.pink),
                          image: DecorationImage(
                              image: NetworkImage(Photo), fit: BoxFit.cover)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            // width: 0,
                            child: Text(
                              userEmail,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('UserSearched')
                            .doc(id)
                            .delete();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Divider(
              height: 5,
              color: Colors.white,
            ),
          )
        ],
      )),
    );
  }

  Widget userTile(
      String userName, String userEmail, String Photo, String uuid, String id) {
    return MaterialButton(
      onPressed: () {},
      child: Container(
          child: Column(
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                // sendMessage(userName);
                FirebaseFirestore.instance
                    .collection('UserSearched')
                    .doc(userName + uiduser)
                    .set({
                  'Name': userName,
                  'Photo': Photo,
                  'Email': userEmail,
                  'uuid': uuid,
                  'uiduser': uiduser,
                }).then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String saveuid = prefs.getString('uid');
                  String createRoom = getRoomId(saveuid, uuid);
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          roomId: createRoom,
                          uuid: uuid,
                          Name: userName,
                          Photo: Photo,
                          Email: userEmail),
                    ),
                  );
                });
              },
              child: Container(
                // color: Colors.pink,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  // color: Colors.pink
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(width: 3, color: Colors.pink),
                          image: DecorationImage(
                              image: NetworkImage(Photo), fit: BoxFit.cover)),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            // width: 0,
                            child: Text(
                              userEmail,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.delete),
                    //   onPressed: () {
                    //     FirebaseFirestore.instance
                    //         .collection('UserSearched')
                    //         .doc(id)
                    //         .delete();
                    //   },
                    // )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Divider(
              height: 5,
              color: Colors.black,
            ),
          )
        ],
      )),
    );
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
