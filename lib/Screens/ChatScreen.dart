import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:commutify/Provider/ProviderData.dart';
import 'package:commutify/Screens/ViewImage.dart';
import 'package:commutify/style/colour.dart';
import 'package:commutify/style/decoration.dart';
import 'package:commutify/style/text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

colour color = colour();
decoration deco = decoration();
text txt = text();
var imageurl;

class ChatScreen extends StatefulWidget {
  String uuid;
  String roomId;
  String Name, Photo, Email;
  String imageurl;
  ChatScreen(
      {@required this.uuid,
      @required this.roomId,
      this.Name,
      this.Photo,
      this.Email});

  @override
  _ChatScreenState createState() => _ChatScreenState(
      uuid: uuid,
      roomId: roomId,
      Name: this.Name,
      Photo: this.Photo,
      Email: this.Email);
}

class _ChatScreenState extends State<ChatScreen> {
  String uuid;
  String roomId;
  String Name, Photo, Email;
  _ChatScreenState({this.uuid, this.roomId, this.Name, this.Photo, this.Email});
  Color a, b, c;
  var Data;
  String uid;
  var Chats;
  BuildContext contxt;
  String message;

  TextEditingController chatController = TextEditingController();
  // var QuerySnapshot;
  var chatsdata;
  @override
  void initState() {
    super.initState();
    getColor();
    getDataShared();
    chatsdata = FirebaseFirestore.instance
        .collection('Chats')
        .doc(roomId)
        .collection('chat')
        .snapshots();

    // Data = FirebaseFirestore.instance.collection('Users').snapshots();
    // Chats=FirebaseFirestore.instance.collection('').snapshots();
  }

  getDataShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
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

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderData>(context);
    onWillPop() {
      Navigator.of(context).pop();
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Navigation()));
    }

    contxt = context;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: color.theme3,
          appBar: AppBar(
            backgroundColor: color.theme1,
            title: Text('Message'),
            actions: [
              IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.white),
                onPressed: () {
                  DialogBoxForeverDelete(context, roomId);
                },
              )
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Flexible(
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Chats')
                        .doc(roomId)
                        .collection('chat')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: Icon(
                                Icons.sentiment_very_dissatisfied_outlined,
                                size: 40,
                                color: color.theme2));
                      }
                      return ListView(
                        reverse: true,
                        children: snapshot.data.docs.map<Widget>((document) {
                          // return Text(document['UserName']);
                          return MessageTile(
                              document['Photo'],
                              document['message'],
                              document['Sender'],
                              document['Reciever'],
                              document['time'],
                              document['File'],
                              document['StringExtra'],
                              document.id,
                              contxt);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
              chatControls(),
            ],
          ),
        ),
        onWillPop: onWillPop);
  }

  void DialogBoxImage(context) {
    var baseDialog = AlertDialog(
      title: new Text(
        "Upload Image",
        style: txt.andika,
      ),
      content: Container(
        child: Text(
          'Enter Text and then Press Image Add Button to Enter Text. ',
          style: txt.andikasmall,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: color.theme1,
          child: new Text("Yes", style: txt.lailaverysmall),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String saveuid = prefs.getString('uid');
            String createRoom = getRoomId(saveuid, uuid);
            FirebaseFirestore.instance
                .collection('ChatRoom')
                .doc(uuid)
                .collection('ChatList')
                .doc(createRoom)
                .update({
              'lastMessage': message == null || message == "" ? '...' : message,
              'check': false,
              'time': Timestamp.now().toString(),
            });
            await FirebaseFirestore.instance
                .collection('Chats')
                .doc(roomId)
                .collection('chat')
                .doc(Timestamp.now().toString())
                .set({
              'Sender': uid,
              'Reciever': uuid,
              'time': Timestamp.now().toString(),
              'message': message == null || message == "" ? '...' : message,
              'Photo': imageurl,
              'File': '',
              'StringExtra': '',
            }).then((value) {
              print('Photo Uploaded');
              FirebaseFirestore.instance
                  .collection('ChatRoom')
                  .doc(uid)
                  .collection('ChatList')
                  .doc(createRoom)
                  .update({
                'lastMessage':
                    message == null || message == "" ? '...' : message,
                'check': false,
                'time': Timestamp.now().toString(),
              });
              chatController.clear();
              setState(() {
                imageurl = "";
              });
            }).catchError((e) {});
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => baseDialog);
  }

  uploadImage() async {
    // imageurl = "";
    print('This Code Will Run');
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child('ChatsImage')
            .child(roomId)
            .child(generateRandomString(200))
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageurl = downloadUrl;
        });
        DialogBoxImage(context);

        // // FirebaseFirestore.instance.collection('Feed').add({
        // //   'Photo': imageurl,
        // //   'Head': heading.text,
        // //   'body': bodymaterial.text,
        // // });

        // print(imageurl);
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  void displayBottomSheet(BuildContext cont) {
    showModalBottomSheet(
        // backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: cont,
        builder: (ctx) {
          return Container(
            height: 200,
          );
        });
  }

  Widget MessageTile(
      String Photo,
      String Message,
      String Sender,
      String Reciever,
      var time,
      String File,
      String StringExtra,
      String id,
      BuildContext context) {
    return Container(
      alignment: uid == Sender ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          DialogBoxDelete(context, id, roomId);
        },
        child: Container(
          decoration: BoxDecoration(
              color: uid == Sender ? color.theme1 : color.theme2,
              borderRadius: BorderRadius.all(Radius.circular(14))),
          padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
          margin: EdgeInsets.only(
              left: uid == Sender ? 60 : 4,
              right: uid == Sender ? 4 : 60,
              top: 4,
              bottom: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Photo == ""
                  ? Container(width: 0, height: 0)
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewImage(Photo)));
                      },
                      child: Container(
                        height: 300,
                        // width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(Photo),
                          ),
                        ),
                      ),
                    ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                child: Text(Message,
                    maxLines: 100,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

// alignment: Sender == uid
//                     ? Alignment.centerRight
//                     : Alignment.centerLeft,
  chatControls() {
    return Container(
      color: color.theme1,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              uploadImage();
            },
            child: Opacity(
              opacity: 1,
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 10),
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: color.theme2, shape: BoxShape.circle),
                child: Icon(
                  Icons.add_a_photo,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: chatController,
              textInputAction: TextInputAction.send,
              onChanged: (input) {
                setState(() {
                  message = input;
                });
              },
              onFieldSubmitted: (value) async {
                setState(() {
                  message = value;
                });
                if (value == "" && chatController.text == "") {
                  Fluttertoast.showToast(
                      msg: "Message Cannot be Empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 2,
                      backgroundColor: color.theme2,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  await FirebaseFirestore.instance
                      .collection('Chats')
                      .doc(roomId)
                      .collection('chat')
                      .doc(Timestamp.now().toString())
                      .set({
                    'Sender': uid,
                    'Reciever': uuid,
                    'time': Timestamp.now().toString(),
                    'message': chatController.text,
                    'Photo': '',
                    'File': '',
                    'StringExtra': '',
                  }).then((type) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String saveuid = prefs.getString('uid');
                    String createRoom = getRoomId(saveuid, uuid);
                    FirebaseFirestore.instance
                        .collection('ChatRoom')
                        .doc(uuid)
                        .collection('ChatList')
                        .doc(roomId)
                        .update({
                      'lastMessage': value,
                      'check': false,
                      'time': Timestamp.now().toString(),
                    });
                    FirebaseFirestore.instance
                        .collection('ChatRoom')
                        .doc(uid)
                        .collection('ChatList')
                        .doc(createRoom)
                        .set({
                      'Name': Name,
                      'Photo': Photo,
                      'Email': Email,
                      'uuid': uuid,
                      'uid': uid,
                      'roomId': createRoom,
                      'lastMessage': chatController.text,
                      'check': false,
                      'time': Timestamp.now().toString(),
                    }).then((value) async {
                      print('hi there');
                    });
                  }).then((value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String saveuid = prefs.getString('uid');
                    String createRoom = getRoomId(saveuid, uuid);
                    FirebaseFirestore.instance
                        .collection('ChatRoom')
                        .doc(uuid)
                        .collection('ChatList')
                        .doc(createRoom)
                        .update({
                      'lastMessage': message,
                      'check': false,
                      'time': Timestamp.now().toString(),
                    });
                  });
                  chatController.clear();
                }
              },
              style: txt.lailaNormal,
              decoration: InputDecoration(
                hintText: 'Say Hi ...',
                hintStyle: txt.lailaNormal,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (chatController.text == "") {
                Fluttertoast.showToast(
                    msg: "Message Cannot be Empty",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 2,
                    backgroundColor: color.theme2,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                await FirebaseFirestore.instance
                    .collection('Chats')
                    .doc(roomId)
                    .collection('chat')
                    .doc(Timestamp.now().toString())
                    .set({
                  'Sender': uid,
                  'Reciever': uuid,
                  'time': Timestamp.now().toString(),
                  'message': chatController.text,
                  'Photo': '',
                  'File': '',
                  'StringExtra': '',
                }).then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String saveuid = prefs.getString('uid');
                  String createRoom = getRoomId(saveuid, uuid);
                  FirebaseFirestore.instance
                      .collection('ChatRoom')
                      .doc(uuid)
                      .collection('ChatList')
                      .doc(roomId)
                      .update({
                    'lastMessage': message,
                    'check': false,
                    'time': Timestamp.now().toString(),
                  });
                  FirebaseFirestore.instance
                      .collection('ChatRoom')
                      .doc(uid)
                      .collection('ChatList')
                      .doc(createRoom)
                      .set({
                    'Name': Name,
                    'Photo': Photo,
                    'Email': Email,
                    'uuid': uuid,
                    'uid': uid,
                    'roomId': createRoom,
                    'lastMessage': chatController.text,
                    'check': false,
                    'time': Timestamp.now().toString(),
                  }).then((value) async {
                    print('hi there');
                  });
                }).then((value) async {
                  chatController.clear();
                });
              }
            },
            child: Opacity(
              opacity: 1,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: color.theme2, shape: BoxShape.circle),
                child: Icon(
                  Icons.send,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void displayBottomSheet(BuildContext cont, String id) {
  showModalBottomSheet(
      // backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: cont,
      builder: (ctx) {
        return Container(
          height: 200,
          child: Column(
            children: [
              MaterialButton(
                onPressed: () {},
              )
            ],
          ),
        );
      });
}

void DialogBoxDelete(context, id, roomId) {
  var baseDialog = AlertDialog(
    title: new Text(
      "Delete Confirmation",
      style: txt.andika,
    ),
    content: Container(
      child: Text(
        'You Really Want to Delete Message?',
        style: txt.andikasmall,
      ),
    ),
    actions: <Widget>[
      FlatButton(
        color: color.theme1,
        child: new Text("Yes", style: txt.lailaverysmall),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('Chats')
              .doc(roomId)
              .collection('chat')
              .doc(id)
              .delete();
          Navigator.pop(context);
        },
      ),
    ],
  );

  showDialog(context: context, builder: (BuildContext context) => baseDialog);
}

void DialogBoxForeverDelete(context, roomId) {
  var baseDialog = AlertDialog(
    title: new Text(
      "Delete Confirmation",
      style: txt.andika,
    ),
    content: Container(
      child: Text(
        'Delete All The Messages Permanently',
        style: txt.andikasmall,
      ),
    ),
    actions: <Widget>[
      FlatButton(
        color: color.theme1,
        child: new Text("Yes", style: txt.lailaverysmall),
        onPressed: () {
          print(roomId);
          FirebaseFirestore.instance
              .collection('Chats')
              .doc(roomId)
              .collection('chat')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });

          Navigator.pop(context);
        },
      ),
    ],
  );

  showDialog(context: context, builder: (BuildContext context) => baseDialog);
}
