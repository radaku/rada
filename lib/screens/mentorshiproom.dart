import 'dart:async';
import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_pickers/chat_pickers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:radauon/emoji_keyboard.dart';
import 'package:radauon/model/messages.dart';
import 'package:radauon/screens/image_viewer.dart';
import 'package:radauon/utils/database_helper.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../emoji_keyboard.dart';

class MentorshipRoom extends StatefulWidget {
  String id;
  String title;
  String image;
  String type;

  MentorshipRoom(
      {Key key, @required this.id, this.title, this.image, this.type})
      : super(key: key);

  @override
  _MentorshipRoomState createState() => _MentorshipRoomState();
}

class _MentorshipRoomState extends State<MentorshipRoom> {
  final navigatorKey = GlobalKey<NavigatorState>();
  //final List<Message> _messages = <Message>[];

  Future<List<Messages>> messages;
  DBHelper dbHelper;

  bool getdata = true;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ScrollController _scrollController = new ScrollController();

  var formatDate = new DateFormat("MMM d,yyyy");
  var formatTime = new DateFormat('EEEE, hh:mm aaa');

  FocusNode textFieldFocus = FocusNode();

  File _image;
  List useruid = [];

  bool _showEmojiPicker = false;

  double h = 0;

  String messager = "";
  String reply = "";
  String replytype = "";
  String replyimage = "";
  String messagetype = "wild";

  int _count = 0;

  bool canSend = false;
  String _messageText = '';
  bool _isShowSticker = false;

  bool search = false;

  bool _share = false;

  bool _show = false;

  String _filetype = "";

  PlatformFile _myfile;
  int _filesize;
  String _filename;

  double _searchwidth = 0;

  bool progress = false;
  String _dprog = "0";

  String _imageurl = "";
  String _sharetext = "";
  String _type = "";
  int _index;
  DocumentSnapshot _doc;
  AsyncSnapshot<QuerySnapshot> _snap;

  final _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    /*notifications();
    initializing();*/
    setState(() {
      getId();
    });
  }

  showKeyboard() => textFieldFocus.toStringShallow();
  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      _showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      _showEmojiPicker = true;
    });
  }

  void getId() async {
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        useruid.add(user.uid);
      });
    });
  }

  void show() {
    final context = navigatorKey.currentState.overlay.context;
    final dialog = AlertDialog(
      content: Container(
        child: Image.network(
            "https://scontent.fdel8-1.fna.fbcdn.net/v/t1.0-9/55786278_1694407227328700_8743813181337501696_n.jpg?_nc_cat=101&_nc_oc=AQnH_MY2ofbfcVeo2-QeS6P10Kg88RnI_zTh78UQGpzY8wVasLyF4hF2_JH0bOB2b8c&_nc_ht=scontent.fdel8-1.fna&oh=ec6eedc22c681f49fa96714991fca364&oe=5D9BC9A5"),
      ),
    );
    showDialog(context: context, builder: (x) => dialog);
  }

  Widget meImage(
      String url,
      String imagename,
      String name,
      String time,
      String sender,
      AsyncSnapshot<QuerySnapshot> snapshot,
      int index,
      String type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageView(
                    url: url,
                    type: "image",
                  )),
        );
      },
      onLongPress: () {
        setState(() {
          _share = true;
          _type = "image";
          _imageurl = url;
          _index = index;
          _snap = snapshot;
        });
        Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            _share = false;
          });
        });
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 0,
              width: 0,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, right: 6),
              color: Colors.white,
              width: 250,
              //height: 250,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, right: 5, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            sender == useruid[0]
                                ? "You"
                                : name.length > 7
                                    ? name.substring(0, 5) + ".."
                                    : name,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                                imageUrl: url.trim(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.colorBurn,
                                          ),
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    Center(child: circularProgress()),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                      child: Icon(
                                        Icons.error,
                                        size: 40,
                                      ),
                                    )),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget senderImage(
      String url,
      String imagename,
      String name,
      String time,
      String sender,
      AsyncSnapshot<QuerySnapshot> snapshot,
      int index,
      String type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageView(
                    url: url,
                    type: "image",
                  )),
        );
      },
      onLongPress: () {
        setState(() {
          _share = true;
          _type = "image";
          _imageurl = url;
          _index = index;
          _snap = snapshot;
        });
        Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            _share = false;
          });
        });
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20, right: 6),
              color: Colors.white,
              width: 250,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, right: 5, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            sender == useruid[0]
                                ? "You"
                                : name.length > 7
                                    ? name.substring(0, 5) + ".."
                                    : name,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                                imageUrl: url.trim(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.colorBurn,
                                          ),
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    Center(child: circularProgress()),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                      child: Icon(
                                        Icons.error,
                                        size: 40,
                                      ),
                                    )),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final _textController = TextEditingController();

  Future getProjectDetails() async {
    List<Messages> messages = await dbHelper.getMessages();
    return messages;
  }

  Widget _buildImageComposer() {
    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.fromLTRB(7, 0, 7, 3),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5),
              height: 47,
              width: 50,
              color: Colors.white,
              child: _filetype == "image"
                  ? Padding(
                      padding: EdgeInsets.all(7),
                      child: Image.asset(
                        "assets/images/image.png",
                        fit: BoxFit.contain,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(7),
                      child: Image.asset(
                        "assets/images/video.png",
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
            Container(
              child: Flexible(
                child: Container(
                  height: 53,
                  child: TextField(
                    controller: _captionController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.grey[200]),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.grey[200]),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(50, 9, 1, 1),
                        prefixIcon: Icon(
                          Icons.insert_emoticon,
                          color: Colors.grey[600],
                          size: 27,
                        ),
                        suffixStyle: TextStyle(color: Colors.white),
                        hintText: "Add caption..."),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 3,
            ),
            Container(
              height: 45,
              width: 45,
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: Colors.blue[600])),
              child: Center(
                child: IconButton(
                    //new
                    icon: Icon(
                      Icons.send,
                      size: 22,
                      color: Colors.white,
                    ), //new
                    /*onPressed: () => _handleSubmitted(_textController.text)),*/
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      if (_captionController.text.isEmpty) {
                        _uploadFile(_myfile, _filename, _filetype, _filesize,
                            _filename, "");
                      } else if (_captionController.text.isNotEmpty) {
                        _uploadFile(_myfile, _filename, _filetype, _filesize,
                            _filename, _captionController.text);
                      }
                    }),
              ), //new
            ), //new
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getId();
    });
    DateTime time = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(time);

    return WillPopScope(
      onWillPop: () {
        if (_isShowSticker) {
          setState(() {
            _isShowSticker = false;
          });
        } else {
          Navigator.pop(context);
        }
        return;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/chat_bg.jpg'),
                fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: Platform.isIOS?AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey[100],
              flexibleSpace: SafeArea(
                child: Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          child: Neumorphic(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.circle(),
                                depth: 0,
                                lightSource: LightSource.topLeft,
                                color: Colors.grey[200]),
                            child: CachedNetworkImage(
                              imageUrl: widget.image,
                              /*placeholder: (context, url) => Center(child: CircularProgressIndicator()),*/
                              placeholder: (context, url) =>
                                  Center(child: circularProgress()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.title,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Say something...",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )),
              ),
            ):AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey[100],
              flexibleSpace: SafeArea(
                child: Container(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          child: Neumorphic(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.circle(),
                                depth: 0,
                                lightSource: LightSource.topLeft,
                                color: Colors.grey[200]),
                            child: CachedNetworkImage(
                              imageUrl: widget.image,
                              /*placeholder: (context, url) => Center(child: CircularProgressIndicator()),*/
                              placeholder: (context, url) =>
                                  Center(child: circularProgress()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.title,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Say something...",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )),
              ),
            ),
            body: Container(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      //Chat list

                      Expanded(
                        flex: 7,
                        child: Container(
                            child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Mentors')
                              .document(widget.id)
                              .collection("messages")
                              .orderBy('created_at', descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            /*SchedulerBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            });*/
                            var messageCount = snapshot.data.documents.length;
                            if (!snapshot.hasData) {
                              return Center(
                                child: circularProgress(),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.fromLTRB(3, 5, 3, 2),
                              child: ListView.builder(
                                reverse: false,
                                shrinkWrap: true,
                                controller: _scrollController,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: messageCount,
                                itemBuilder: (_, int index) {
                                  final DocumentSnapshot document =
                                      snapshot.data.documents[index];
                                  final dynamic msg = document['message'];
                                  final dynamic d = document['date'];
                                  final dynamic t = document['time'];
                                  final dynamic sender = document['sender'];
                                  final dynamic name = document['name'];
                                  final dynamic type = document['type'];

                                  if (type == "message") {
                                    if (sender == useruid[0]) {
                                      return SwipeGestureRecognizer(
                                        onSwipeLeft: () {
                                          setState(() {
                                            messager = name;
                                            reply = msg;
                                            replytype = type;
                                            replyimage = "";
                                            messagetype = "reply";
                                            h = 55;
                                          });
                                        },
                                        onSwipeRight: () {
                                          setState(() {
                                            messager = name;
                                            reply = msg;
                                            replytype = type;
                                            replyimage = "";
                                            messagetype = "reply";
                                            h = 55;
                                          });
                                        },
                                        //child: meBubble(msg, name, t),
                                        child: chatBubble(
                                            msg,
                                            sender,
                                            name,
                                            type,
                                            index,
                                            snapshot,
                                            document,
                                            time.toString()),
                                      );
                                    } else {
                                      return SwipeGestureRecognizer(
                                          onSwipeLeft: () {
                                            setState(() {
                                              messager = name;
                                              reply = msg;
                                              replytype = type;
                                              replyimage = "";
                                              messagetype = "reply";
                                              h = 55;
                                            });
                                            print(replytype);
                                          },
                                          onSwipeRight: () {
                                            setState(() {
                                              messager = name;
                                              reply = msg;
                                              replytype = type;
                                              replyimage = "";
                                              messagetype = "reply";
                                              h = 55;
                                            });
                                            print(replytype);
                                          },
                                          //child: senderBubble(msg, name, t));
                                          child: chatBubble(
                                              msg,
                                              sender,
                                              name,
                                              type,
                                              index,
                                              snapshot,
                                              document,
                                              time.toString()));
                                    }

                                    //return senderBubble(msg,name,t);
                                  } else if (type == 'image') {
                                    //return meImage(document['url']);

                                    if (document['sender'] == useruid[0]) {
                                      return SwipeTo(
                                        swipeDirection:
                                            SwipeDirection.swipeToLeft,
                                        endOffset: Offset(-0.3, 0.0),
                                        callBack: () {
                                          setState(() {
                                            messager = name;
                                            reply = msg;
                                            replytype = type;
                                            replyimage = document['url'];
                                            h = 55;
                                          });
                                        },
                                        child: meImage(
                                            document['url'],
                                            document['imagename'],
                                            document['name'],
                                            document['time'],
                                            document['sender'],
                                            snapshot,
                                            index,
                                            type),
                                      );
                                    } else {
                                      return SwipeTo(
                                        swipeDirection:
                                            SwipeDirection.swipeToRight,
                                        endOffset: Offset(0.3, 0.0),
                                        callBack: () {
                                          setState(() {
                                            messager = name;
                                            reply = msg;
                                            replytype = type;
                                            replyimage = document['url'];
                                            h = 55;
                                          });
                                        },
                                        child: senderImage(
                                            document['url'],
                                            document['imagename'],
                                            document['name'],
                                            document['time'],
                                            document['sender'],
                                            snapshot,
                                            index,
                                            type),
                                      );
                                    }
                                  } else if (type == "reply") {
                                    if (sender == useruid[0]) {
                                      return SwipeGestureRecognizer(
                                        onSwipeLeft: () {
                                          /*setState(() {
                                            messager = name;
                                            reply = msg;
                                            replytype = type;
                                            replyimage = "";
                                            h = 55;
                                          });
                                          print(replytype);*/
                                        },
                                        onSwipeRight: () {
                                          /*setState(() {
                                            messager = name;
                                            reply = msg;
                                            replytype = type;
                                            replyimage = "";
                                            h = 55;
                                          });*/
                                        },
                                        child: document['url'] == ""
                                            ? meReply(
                                                msg, name, t, document['reply'])
                                            : replymeImage(sender,
                                                document['url'], msg, name),
                                      );
                                    } else {
                                      return SwipeGestureRecognizer(
                                          onSwipeLeft: () {
                                            /*setState(() {
                                              messager = name;
                                              reply = msg;
                                              replytype = type;
                                              replyimage = "";
                                              h = 55;
                                            });
                                            print(replytype);*/
                                          },
                                          onSwipeRight: () {
                                            /*setState(() {
                                              messager = name;
                                              reply = msg;
                                              replytype = type;
                                              replyimage = "";
                                              h = 55;
                                            });
                                            print(replytype);*/
                                          },
                                          child: senderReply(
                                              msg, name, t, document['reply']));
                                      /*child: messageReply(msg, name, t,
                                              document['reply'], sender));*/
                                    }
                                  } else if (type == "video") {
                                    if (sender == useruid[0]) {
                                      return meVideo(
                                        document["url"],
                                        document["thumb"],
                                        document["filename"],
                                        document["name"],
                                        document["time"],
                                        sender,
                                        snapshot,
                                        index,
                                        document["type"],
                                        document["caption"],
                                      );
                                    } else {
                                      return senderVideo(
                                          document["url"],
                                          document["thumb"],
                                          document["filename"],
                                          document["name"],
                                          document["time"],
                                          sender,
                                          snapshot,
                                          index,
                                          document["type"]);
                                    }
                                  }

                                  return SizedBox(
                                    height: 0,
                                    width: 0,
                                  );
                                },
                              ),
                            );
                          },
                        )),
                      ),

                      //chat list end

                      //Expanded(child: new Divider(height: 0.0)),
                      replytype == "image"
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  topRight: Radius.circular(0.0)),
                              child: AnimatedContainer(
                                width: MediaQuery.of(context).size.width,
                                height: h,
                                curve: Curves.easeIn,
                                duration: Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      //                   <--- left side
                                      color: Colors.blueAccent,
                                      width: 3.0,
                                    ),
                                    top: BorderSide(
                                      //                   <--- left side
                                      color: Colors.grey[100],
                                      width: 1.0,
                                    ),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        child: Text(
                                          messager,
                                          style: TextStyle(
                                              color: Colors.green[400],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        top: 7,
                                        left: 5,
                                      ),
                                      Positioned(
                                        child: Icon(
                                          Icons.image,
                                          color: Colors.grey[600],
                                        ),
                                        top: 25,
                                      ),
                                      Positioned(
                                        child: Text(
                                          "Image",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        top: 30,
                                        left: 30,
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 2,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            height: 45,
                                            width: 45,
                                            color: Colors.white,
                                            child: CachedNetworkImage(
                                              imageUrl: replyimage,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.colorBurn,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child:
                                                          circularProgress()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Center(
                                                child: Icon(
                                                  Icons.error,
                                                  size: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              h = 0;
                                            });
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle),
                                            child: Center(
                                              child: Text(
                                                '-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        right: 0,
                                        top: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  topRight: Radius.circular(0.0)),
                              child: AnimatedContainer(
                                width: MediaQuery.of(context).size.width,
                                height: h,
                                curve: Curves.easeInCubic,
                                duration: Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      //                   <--- left side
                                      color: Colors.blueAccent,
                                      width: 3.0,
                                    ),
                                    top: BorderSide(
                                      //                   <--- left side
                                      color: Colors.grey[100],
                                      width: 1.0,
                                    ),
                                  ),
                                  color: Colors.grey[200],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        child: Text(
                                          messager,
                                          style: TextStyle(
                                              color: Colors.green[400],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        top: 7,
                                        left: 5,
                                      ),
                                      Positioned(
                                        child: reply.length > 35
                                            ? Text(
                                                reply.substring(0, 35) + "...",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              )
                                            : Text(
                                                reply,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              ),
                                        top: 25,
                                        left: 5,
                                      ),
                                      Positioned(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              h = 0;
                                            });
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle),
                                            child: Center(
                                              child: Text(
                                                '-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        right: 5,
                                        top: 15,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      Padding(
                          padding:
                              EdgeInsets.only(right: 10, left: 10, bottom: 10),
                          child: !_show
                              ? _buildMessageComposer()
                              : _buildImageComposer()),
                      EmojiContainer(),
                      /*Expanded(
                        flex: 1,
                        child: Container(
                            height: 65,
                            margin: EdgeInsets.only(bottom: 1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(width: 1.0, color: Colors.white),
                                left: BorderSide(width: 1.0, color: Colors.white),
                                right:
                                    BorderSide(width: 1.0, color: Colors.white),
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.white),
                              ),
                            ),
                            child: IconTheme(
                                data: IconThemeData(
                                    color: Theme.of(context).accentColor),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Row(
                                    children: <Widget>[
                                      //left send button

                                      Container(
                                        width: 48.0,
                                        height: 48.0,
                                        child: _showEmojiPicker == false
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.insert_emoticon,
                                                  color: Colors.grey[600],
                                                  size: 27,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _showEmojiPicker = true;
                                                  });
                                                  textFieldFocus.unfocus();
                                                  showEmojiContainer();
                                                },
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.keyboard,
                                                  color: Colors.white,
                                                  size: 27,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _showEmojiPicker = false;
                                                  });
                                                  textFieldFocus.requestFocus();
                                                  showKeyboard();
                                                },
                                              ),
                                      ),

                                      //Enter Text message here
                                      Flexible(
                                        child: TextField(
                                          controller: _textController,
                                          focusNode: textFieldFocus,
                                          style:
                                              TextStyle(color: Colors.grey[600]),
                                          onTap: () => hideEmojiContainer(),
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration.collapsed(
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[600]),
                                              hintText: "Write a message"),
                                        ),
                                      ),

                                      //gallery button
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 2.0),
                                        width: 48.0,
                                        height: 48.0,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.image,
                                              size: 27,
                                              color: Colors.grey[600],
                                            ),
                                            onPressed: () {
                                              _imagePicker();
                                            }),
                                      ),

                                      //right send button

                                      Container(
                                        margin: EdgeInsets.only(right: 2),
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.blueAccent)),
                                        child: GestureDetector(
                                          onTap: () {
                                            */ /*_sendMessage(widget.id+useruid[0],_textController.text);*/ /*
                                            if (_textController.text.isNotEmpty) {
                                              _sendMessage(widget.id,
                                                  _textController.text);
                                            } else {
                                              //notification();
                                            }
                                          },
                                          child: Center(
                                            child: Padding(
                                                padding: EdgeInsets.only(left: 4),
                                                child: Icon(
                                                  Icons.send,
                                                  size: 24,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                      ),*/
                      _showEmojiPicker == true
                          ? Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              child: EmojiKeyboard(
                                onEmojiPressed: (emoji) {
                                  _textController.text =
                                      _textController.text + emoji.emoji;
                                },
                              ),
                            )
                          : SizedBox(
                              height: 0,
                              width: 0,
                            )
                    ],
                  ),
                ))),
      ),
    );
  }

  Widget replymeImage(
      String sender, String image, String message, String name) {
    return sender == useruid[0]
        ? Align(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 260),
              child: Bubble(
                margin: BubbleEdges.only(top: 10),
                elevation: 0,
                alignment: Alignment.topLeft,
                nip: BubbleNip.leftTop,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.red[900], fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: Row(
                        children: [
                          Column(
                            children: [Text("Image"), Icon(Icons.image)],
                          )
                        ],
                      ),
                    ),
                    Text(message)
                  ],
                ),
              ),
            ),
          )
        : Align(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 260),
              child: Bubble(
                margin: BubbleEdges.only(top: 10),
                elevation: 0,
                alignment: Alignment.topRight,
                nip: BubbleNip.rightTop,
                color: Colors.blue[400],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You",
                      style: TextStyle(
                          color: Colors.brown, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget meVideo(
      String url,
      String thumb,
      String imagename,
      String name,
      String time,
      String sender,
      AsyncSnapshot<QuerySnapshot> snapshot,
      int index,
      String type,
      String caption) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageView(
                    url: url.trim(),
                    type: "video",
                  )),
        );
      },
      onLongPress: () {
        setState(() {
          _share = true;
          _type = "image";
          _imageurl = url;
          _index = index;
          _snap = snapshot;
        });
        Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            _share = false;
          });
        });
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 0,
              width: 0,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, right: 6),
              color: Colors.white,
              width: 250,
              //height: 250,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, right: 5, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            sender == useruid[0]
                                ? "You"
                                : name.length > 7
                                    ? name.substring(0, 5) + ".."
                                    : name,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  caption == null
                      ? SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 0, left: 5, right: 5, bottom: 5),
                                child: Text(caption.toString()))
                          ],
                        ),
                  Container(
                    margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                    imageUrl: thumb.trim(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.colorBurn,
                                              ),
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                        Center(child: circularProgress()),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                          child: Icon(
                                            Icons.error,
                                            size: 40,
                                          ),
                                        )),
                              ],
                            )),
                        Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 60,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget senderVideo(
      String url,
      String thumb,
      String imagename,
      String name,
      String time,
      String sender,
      AsyncSnapshot<QuerySnapshot> snapshot,
      int index,
      String type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageView(
                    url: url,
                    type: "video",
                  )),
        );
      },
      onLongPress: () {
        setState(() {
          _share = true;
          _type = "image";
          _imageurl = url;
          _index = index;
          _snap = snapshot;
        });
        Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            _share = false;
          });
        });
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20, right: 6),
              color: Colors.white,
              width: 250,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, right: 5, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            sender == useruid[0]
                                ? "You"
                                : name.length > 7
                                    ? name.substring(0, 5) + ".."
                                    : name,
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 2, right: 2, bottom: 2),
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                    imageUrl: thumb.trim(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.colorBurn,
                                              ),
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                        Center(child: circularProgress()),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                          child: Icon(
                                            Icons.error,
                                            size: 40,
                                          ),
                                        )),
                              ],
                            )),
                        Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 60,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadToFirebase(String url, String type, int size, String name, String thumb,
      String caption) async {
    var documentReference =
        Firestore.instance.collection('ForumRooms').document(widget.id);

    FirebaseUser user = await _firebaseAuth.currentUser();

    var datetime = new DateTime.now();
    var date = formatDate.format(datetime);
    var time = formatTime.format(datetime);

    await Firestore.instance
        .collection("Users")
        .document(useruid[0])
        .get()
        .then((value) {
      var v = value;

      documentReference.collection("messages").add({
        'message': caption,
        'sender': user.uid,
        'date': date,
        'time': time,
        'cousellor_avata': widget.image,
        'student_avata': widget.image,
        'name': value.data['name'],
        'type': type,
        'size': size.toString(),
        'filename': name,
        'url': url,
        'thumb': thumb,
        'title': widget.title,
        'created_at': DateTime.now()
      }).then((value) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
      });
    });
  }

  Future<void> _uploadFile(PlatformFile file, String filename, String type,
      int size, String name, String caption) async {
    _captionController.text = "";
    setState(() {
      _show = false;
    });

    FirebaseUser user = await _firebaseAuth.currentUser();

    var datetime = new DateTime.now();
    var date = formatDate.format(datetime);
    var time = formatTime.format(datetime);

    /*String fileName = basename(file.path);*/
    String fileName = file.name;

    try {
      FormData formData = new FormData.fromMap({
        "name": "rajika",
        "age": 22,
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Response response = await Dio().post(
          "https://mysitemose.000webhostapp.com/uploads.php",
          data: formData);

      if (type == "video") {
        final uint8list = await VideoThumbnail.thumbnailFile(
          video: response.data.trim(),
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.PNG,
          maxHeight: 350,
          quality: 75,
        );

        String thumbName =
            DateTime.now().millisecondsSinceEpoch.toString() + "." + "png";

        FormData thumbData = new FormData.fromMap({
          "name": "rajika",
          "age": 22,
          "file": await MultipartFile.fromFile(File(uint8list).path,
              filename: thumbName),
        });

        Response thumbresponse = await Dio().post(
            "https://mysitemose.000webhostapp.com/uploads.php",
            data: thumbData);
        uploadToFirebase(
            response.data, type, size, name, thumbresponse.data, caption);
      } else if (type == "image") {
        uploadToFirebase(
            response.data, type, size, name, response.data, caption);
      } else if (type == "docx") {
        uploadToFirebase(
            response.data, type, size, name, response.data, caption);
      } else if (type == "pdf") {
        uploadToFirebase(
            response.data, type, size, name, response.data, caption);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildMessageComposer() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: AlignmentDirectional.topStart,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(24)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: _isShowSticker
                          ? Icon(Icons.keyboard)
                          : Icon(Icons.insert_emoticon),
                      iconSize: 24,
                      color: Colors.grey[600],
                      onPressed: () {
                        setState(() {
                          _isShowSticker
                              ? SystemChannels.textInput
                                  .invokeMethod('TextInput.show')
                              : SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');

                          _isShowSticker = !_isShowSticker;
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onTap: () {
                        setState(() {
                          _isShowSticker = false;
                        });
                      },
                      onChanged: (value) {
                        _messageText = value;
                        setState(() {
                          canSend = value.trim().isNotEmpty;
                        });
                      },
                      controller: _textController,
                      focusNode: textFieldFocus,
                      // onSubmitted: _handleSubmit,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: "Type a message",
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Material(
                        child: InkWell(
                          child: RotationTransition(
                            turns: const AlwaysStoppedAnimation(45 / 360),
                            /*child: GestureDetector(
                              onTap: () {
                                _filePicker();
                              },
                              child: Icon(Icons.attach_file,
                                  color: Colors.grey[600], size: 24),
                            ),*/
                          ),
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: 14),
                      /*Material(
                        child: InkWell(
                          child: Icon(Icons.camera_alt,
                              color: Colors.grey[600], size: 24),
                          onTap: () {
                            _imagePicker();
                          },
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //   _chatController.text.isEmpty
        SizedBox(width: 6),
        Container(
          margin: new EdgeInsets.only(right: 2),
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
              color: Colors.blue.withAlpha(200),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 1, color: Colors.white.withAlpha(30))),
          child: GestureDetector(
            onTap: () {
              if (_textController.text.isNotEmpty) {
                _sendMessage(widget.id, _textController.text);
              } else {
                //notification();
              }
            },
            child: Center(
              child: Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.send,
                    size: 24,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget EmojiContainer() {
    return SingleChildScrollView(
      child: Container(
        height: !_isShowSticker ? 0 : 270,
        child: ChatPickers(
          chatController: _textController,
          emojiPickerConfig: EmojiPickerConfig(
            columns: 8,
            numRecommended: 10,
            bgBarColor: Colors.black,
            bgColor: Colors.grey[900],
            /* bgColor: Colors.white,*/
          ),
          giphyPickerConfig: GiphyPickerConfig(
              apiKey: "q3KulxGCIKWrOU283I3xM3DWvMnO5zOV",
              onSelected: (gif) {
                //_addGifMessage(gif);
              }),
        ),
      ),
    );
  }

  Widget emojiContainer() {
    /*return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: Colors.blue,
      rows: 3,
      columns: 7,
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        print(emoji);
      },
    );*/
  }

  void _sendMsg(String msg, String messageDirection, String date) {
    if (msg.length == 0) {
    } else {
      _textController.clear();

      setState(() {
        //_messages.insert(0, Message);
      });
    }
  }

  _showCaption(String extention) async {
    setState(() {
      _show = true;
    });

    if (extention == "jpg" ||
        extention == "png" ||
        extention == "jpeg" ||
        extention == "webp") {
      setState(() {
        _filetype = "image";
      });
    } else if (extention == "mp4") {
      setState(() {
        _filetype = "video";
      });
    }
  }

  void _imagePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'mp4', 'png', 'webp'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        _myfile = file;
        _filename = file.name;
        _filesize = file.size;
      });

      _showCaption(file.extension);

      /*if (file.extension == "mp4") {
        await _uploadFile(
            file,
            "rada" + DateTime.now().millisecondsSinceEpoch.toString(),
            "video",
            file.size,
            file.name);
      } else if (file.extension == "jpg" ||
          file.extension == "jpeg" ||
          file.extension == "png") {
        await _uploadFile(
            file,
            "rada" + DateTime.now().millisecondsSinceEpoch.toString(),
            "image",
            file.size,
            file.name);
      } else if (file.extension == "docx") {
        await _uploadFile(
            file,
            "rada" + DateTime.now().millisecondsSinceEpoch.toString(),
            "docx",
            file.size,
            file.name);
      } else if (file.extension == "pdf") {
        await _uploadFile(
            file,
            "rada" + DateTime.now().millisecondsSinceEpoch.toString(),
            "pdf",
            file.size,
            file.name);
      }*/
    }
  }

  Widget chatBubble(
      String message,
      String sender,
      String name,
      String type,
      int index,
      AsyncSnapshot<QuerySnapshot> snapshot,
      DocumentSnapshot documentSnapshot,
      String time) {
    return sender != useruid[0]
        ? Align(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 260),
              child: Bubble(
                margin: BubbleEdges.only(top: 10),
                elevation: 0,
                alignment: Alignment.topLeft,
                nip: BubbleNip.leftTop,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.red[900], fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(message)
                  ],
                ),
              ),
            ),
          )
        : Align(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 260),
              child: Bubble(
                margin: BubbleEdges.only(top: 10),
                elevation: 0,
                alignment: Alignment.topRight,
                nip: BubbleNip.rightTop,
                color: Colors.teal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You",
                      style: TextStyle(
                          color: Colors.brown, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget circularProgress() {
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
              /*color: index.isEven ? Colors.blue : Colors.white,*/
              shape: BoxShape.circle,
              color: Colors.amber),
        );
      },
    );
  }

  void _sendMessage(String id, String message) async {
    _textController.clear();
    replyimage = "";
    setState(() {
      h = 0;
    });

    List namelist = [];

    FirebaseUser user = await _firebaseAuth.currentUser();

    var datetime = new DateTime.now();
    var date = formatDate.format(datetime);
    var time = formatTime.format(datetime);

    var documentReference =
        Firestore.instance.collection('Mentors').document(widget.id);

    await FirebaseAuth.instance.currentUser();
    if (messagetype == "wild") {
      await Firestore.instance
          .collection("Users")
          .document(useruid[0])
          .get()
          .then((value) {
        documentReference.collection("messages").add({
          'message': message,
          'sender': user.uid,
          'date': date,
          'time': time,
          'avata': widget.image,
          'name': value.data['name'],
          'type': 'message',
          'mentor': widget.id,
          'reply': "",
          'url': "",
          'created_at': DateTime.now().millisecondsSinceEpoch.toString()
        }).then((value) {
          textFieldFocus.unfocus();
          _showEmojiPicker = false;
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          //scrolling code
        });
      });
    } else if (messagetype == "reply") {
      await Firestore.instance
          .collection("Users")
          .document(useruid[0])
          .get()
          .then((value) {
        documentReference.collection("messages").add({
          'message': message,
          'sender': user.uid,
          'date': date,
          'time': time,
          'avata': widget.image,
          'name': value.data['name'],
          'type': 'reply',
          'mentor': widget.id,
          'url': "",
          'reply': reply,
          'created_at': DateTime.now().millisecondsSinceEpoch.toString()
        }).then((value) {
          messagetype = "wild";
          textFieldFocus.unfocus();
          _showEmojiPicker = false;
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          //scrolling code
        });
      });
    }
  }

  Widget meBubble(message, name, time) {
    return getSenderView(ChatBubbleClipper4(type: BubbleType.sendBubble),
        context, message, name, time);
  }

  Widget senderBubble(message, name, time) {
    return getReceiverView(ChatBubbleClipper4(type: BubbleType.receiverBubble),
        context, message, name, time);
  }

  Widget meReply(message, name, time, reply) {
    return getSenderReply(ChatBubbleClipper4(type: BubbleType.sendBubble),
        context, message, name, time, reply);
  }

  Widget senderReply(message, name, time, reply) {
    return getReceiverReply(ChatBubbleClipper4(type: BubbleType.receiverBubble),
        context, message, name, time, reply);
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  getSenderView(CustomClipper clipper, BuildContext context, String message,
          String name, String time) =>
      ChatBubble(
        clipper: clipper,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Color(0xffE7E7ED),
        elevation: 0,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Wrap(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  SelectableLinkify(
                    onOpen: _onOpen,
                    text: '$message',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Raleway-regular',
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    time,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Raleway-regular',
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.done_all,
                    color: Colors.green,
                    size: 20,
                  )
                ],
              )
            ],
          ),
        ),
      );

  getReceiverView(
          CustomClipper clipper, BuildContext context, message, name, time) =>
      ChatBubble(
        clipper: clipper,
        //backGroundColor: Color(0xff195e83),
        backGroundColor: Colors.grey.withAlpha(40),
        margin: EdgeInsets.only(top: 20),
        elevation: 0,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Wrap(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  SelectableLinkify(
                    textAlign: TextAlign.start,
                    onOpen: _onOpen,
                    text: '$message',
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Raleway-regular',
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$name $time",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Raleway-regular',
                        fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          ),
        ),
      );

  getSenderReply(CustomClipper clipper, BuildContext context, String message,
          String name, String time, reply) =>
      ChatBubble(
        clipper: clipper,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Colors.grey[100],
        elevation: 0,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Wrap(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            reply.length <= 70
                                ? reply
                                : reply.toString().substring(0, 70) + "...",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: SelectableLinkify(
                      textAlign: TextAlign.start,
                      onOpen: _onOpen,
                      text: '$message',
                      style: TextStyle(
                        color: Colors.black,
                        /*fontWeight: FontWeight.w600*/
                      ),
                    ),
                  ),
                ],
              ),
              //Divider(),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "$time",
                      style: TextStyle(
                          color: Colors.red[900],
                          fontFamily: 'Raleway-regular',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );

  getReceiverReply(CustomClipper clipper, BuildContext context, message, name,
          time, reply) =>
      ChatBubble(
        clipper: clipper,
        backGroundColor: Colors.white,
        elevation: 0,
        margin: EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Wrap(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.grey[100],
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        children: <Widget>[
                          Text(
                            reply.length >= 70
                                ? reply.toString().substring(0, 70)
                                : reply.toString(),
                            //reply.length<=96?reply:reply.toString().substring(0,96)+"...",
                            style: TextStyle(
                                color: Colors.red[900],
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: SelectableLinkify(
                      textAlign: TextAlign.start,
                      onOpen: _onOpen,
                      text: '$message',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$name $time",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Raleway-regular',
                        fontWeight: FontWeight.w500),
                  )
                ],
              )
            ],
          ),
        ),
      );
}
