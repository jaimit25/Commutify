import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commutify/Provider/ProviderData.dart';
import 'package:commutify/Screens/ChatScreen.dart';
import 'package:commutify/style/colour.dart';
import 'package:flutter/material.dart';
import 'package:commutify/style/decoration.dart';
import 'package:commutify/style/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

colour color = colour();
decoration deco = decoration();
text txt = text();

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
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
    onWillPop() {}
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
            // FirebaseFirestore.instance
            //             .collection('Chats')
            //             .doc(roomId)
            //             .collection('chat')
            //             .orderBy('time', descending: true)
            //             .snapshots()
            stream: FirebaseFirestore.instance
                // .collection('Chats')
                // .doc(createRoom)
                .collection('ChatRoom')
                .doc(provider.uid)
                .collection('ChatList')
                .orderBy('time', descending: true)
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
                  return userTile(
                      document['Name'],
                      document['Email'],
                      document['Photo'],
                      document['uid'],
                      document['uuid'],
                      document['lastMessage'],
                      document['check'],
                      document['roomId'],
                      document.id);
                }).toList(),
              );
            },
          ),
        ),
        onWillPop: onWillPop);
  }

  void DialogBoxForeverDelete(roomId, uid, uuid, id) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Delete",
        style: txt.andika,
      ),
      content: Container(
        child: Text(
          'Your Chat Room is Deleted Successfully',
          style: txt.andikasmall,
        ),
      ),
      // actions: <Widget>[
      // FlatButton(
      //   color: color.theme1,
      //   child: new Text("Yes", style: txt.lailaverysmall),
      //   onPressed: () {
      //     // print(roomId);
      //     // String createRoom = getRoomId(uid, uuid);
      //     // FirebaseFirestore.instance
      //     //     .collection('ChatRoom')
      //     //     .doc(uid)
      //     //     .collection('ChatList')
      //     //     .doc(roomId)
      //     //     .delete();
      //     // Navigator.pop(context);
      //   },
      // ),
      // ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  Widget userTile(String Name, String Email, String Photo, String uid,
      String uuid, String lastmessage, var check, String roomId, String id) {
    return MaterialButton(
      onLongPress: () {
        FirebaseFirestore.instance
            .collection('ChatRoom')
            .doc(uid)
            .collection('ChatList')
            .doc(roomId)
            .delete();
        DialogBoxForeverDelete(roomId, uid, uuid, id);
      },
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String saveuid = prefs.getString('uid');
        FirebaseFirestore.instance
            .collection('ChatRoom')
            .doc(uuid)
            .collection('ChatList')
            .doc(roomId)
            .update({
          'check': true,
        });
        FirebaseFirestore.instance
            .collection('ChatRoom')
            .doc(uid)
            .collection('ChatList')
            .doc(roomId)
            .update({
          'check': true,
        }).then((value) async {
          String createRoom = getRoomId(saveuid, uuid);
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                roomId: createRoom,
                uuid: uuid,
                Name: Name,
                Photo: Photo,
                Email: Email,
              ),
            ),
          );
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   height: 60,
                //   width: 60,
                //   decoration: BoxDecoration(
                //       // border: Border.all(color: color.theme1, width: 2),
                //       shape: BoxShape.circle,
                //       image: DecorationImage(
                //         fit: BoxFit.cover,
                //         image: NetworkImage(Photo),
                //       )),
                // ),
                Container(
                  height: 60,
                  width: 60,
                  child: Stack(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            // border: Border.all(color: color.theme1, width: 2),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(Photo),
                            )),
                      ),
                      check
                          ? Container()
                          : Container(
                              height: 14,
                              width: 14,
                              margin: EdgeInsets.only(top: 45, left: 45),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: color.theme1),
                            ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Name == null || Name == "" ? 'Name' : Name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        lastmessage == null || lastmessage == ""
                            ? 'Photo'
                            : lastmessage,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.5,
                            // color: Colors.grey[700],
                            color: check ? Colors.grey[600] : Colors.grey[900],
                            fontWeight:
                                check ? FontWeight.w600 : FontWeight.w800),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              child: Divider(
                color: color.theme1,
              ),
            )
          ],
        ),
      ),
    );
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
}
