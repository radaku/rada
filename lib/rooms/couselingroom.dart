import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:radauon/rooms/roomtwo.dart';
import 'package:radauon/services/message.dart';
import 'package:radauon/services/user.dart';

class CounselingRoom extends StatefulWidget {

  /*String id;
  String image,
  String name;
  String status;*/
  String id;
  String image;
  String name;
  String status;
  String counselorid;

  CounselingRoom({Key key, @required this.id,this.name,this.image,this.status,this.counselorid}) : super(key: key);

  @override
  _CounselingRoomState createState() => _CounselingRoomState();
}

class _CounselingRoomState extends State<CounselingRoom> {

  final navigatorKey = GlobalKey<NavigatorState>();
  final List<Message> _messages = <Message>[];

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //ScrollController _controller = ScrollController();
  ScrollController _scrollController=new ScrollController();

  var formatDate=new DateFormat("MMM d,yyyy");
  /*var formatTime=new DateFormat('EEEE, hh:mm aaa');*/
  var formatTime=new DateFormat('EEEE, hh:mm aaa');

  List useruid=[];

  @override
  void initState() {
    super.initState();
    setState(() {
      getId();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }



  void getId() async{
    await _firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        useruid.add(user.uid);
      });
    });
  }

  void show() {
    final context = navigatorKey.currentState.overlay.context;
    final dialog = AlertDialog(
      content: Container(child: Image.network("https://scontent.fdel8-1.fna.fbcdn.net/v/t1.0-9/55786278_1694407227328700_8743813181337501696_n.jpg?_nc_cat=101&_nc_oc=AQnH_MY2ofbfcVeo2-QeS6P10Kg88RnI_zTh78UQGpzY8wVasLyF4hF2_JH0bOB2b8c&_nc_ht=scontent.fdel8-1.fna&oh=ec6eedc22c681f49fa96714991fca364&oe=5D9BC9A5"),),
    );
    showDialog(context: context, builder: (x) => dialog);
  }


  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    setState(() {
      getId();
    });
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(time);

    return Scaffold(
        appBar: Platform.isIOS?AppBar(
          backgroundColor: Colors.white,
          leading: Icon(Icons.arrow_back_ios,color: Colors.blueAccent,size: 27,),
          title: Text(
            widget.name,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          elevation: 0,
          actions: <Widget>[
            Padding(padding: EdgeInsets.only(right: 15),child: Icon(Icons.more_horiz,size: 27,color: Colors.blueAccent,)),
          ],
        ):AppBar(
          backgroundColor: Colors.white,
          leading: Icon(Icons.arrow_back,color: Colors.blueAccent,size: 27,),
          title: Text(
            widget.name,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          elevation: 0,
          actions: <Widget>[
            Padding(padding: EdgeInsets.only(right: 15),child: Icon(Icons.more_horiz,size: 27,color: Colors.blueAccent,)),
          ],
        ),
        body: new Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: new Container(
              child: new Column(
                children: <Widget>[

                  //Chat list
                  /*new Flexible(
                    child: new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      *//*itemCount: _messages.length,*//*
                      itemCount: 1,
                      itemBuilder: (_, int index) => meBubble("This is a message"),
                    ),
                  ),*/

                  Expanded(
                    flex:7,
                    child: new Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('CounsellingRooms')
                              .document(widget.id+useruid[0])
                              .collection("messages")
                              .orderBy('created_at', descending: false)
                          /*.limit(20)*/
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) return Center(child: circularProgress(),);
                            final int messageCount = snapshot.data.documents.length;
                            return Padding(
                              padding: EdgeInsets.fromLTRB(3, 5, 3, 2),
                              child: ListView.builder(
                                reverse: false,
                                shrinkWrap: true,
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics (),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (_, int index) {
                                  final DocumentSnapshot document = snapshot.data.documents[index];
                                  final dynamic msg = document['message'];
                                  final dynamic d = document['date'];
                                  final dynamic t = document['time'];
                                  final dynamic sender = document['sender'];
                                  final dynamic name = document['name'];
                                  final dynamic type = document['type'];

                                  if(type=="message"){

                                    if(sender==useruid[0]){
                                      return meBubble(msg,name,t);
                                    }else{
                                      return senderBubble(msg,name,t);
                                    }

                                    //return senderBubble(msg,name,t);
                                  }else if(type=='image'){

                                  }

                                  return SizedBox(height: 0,width: 0,);

                                },
                              ),
                            );
                          },
                        )
                    ),
                  ),

                  //chat list end


                  //Expanded(child: new Divider(height: 0.0)),
                  Expanded(
                    flex: 1,
                    child: new Container(
                        height: 55,
                        margin: EdgeInsets.only(bottom: 1),
                        decoration:
                        new BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey[200]),
                            left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
                            right: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
                            bottom: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
                          ),
                        ),
                        child: new IconTheme(
                            data: new IconThemeData(
                                color: Theme.of(context).accentColor),
                            child: new Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: new Row(
                                children: <Widget>[
                                  //left send button

                                  new Container(
                                    width: 48.0,
                                    height: 48.0,
                                    child: new IconButton(
                                        icon: Icon(Icons.insert_emoticon,color: Colors.grey,size: 27,),
                                        onPressed: () => _sendMsg(
                                            _textController.text,
                                            'left',
                                            formattedDate)),
                                  ),

                                  //Enter Text message here
                                  new Flexible(
                                    child: new TextField(
                                      controller: _textController,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: "Enter message"),
                                    ),
                                  ),

                                  //gallery button
                                  new Container(
                                    margin:
                                    new EdgeInsets.symmetric(horizontal: 2.0),
                                    width: 48.0,
                                    height: 48.0,
                                    child: new IconButton(
                                        icon: Icon(Icons.image,size: 27,color: Colors.grey,),
                                        onPressed: () => _sendMsg(
                                            _textController.text,
                                            'right',
                                            formattedDate)),
                                  ),

                                  //right send button

                                  new Container(
                                    margin:
                                    new EdgeInsets.only(right: 2),
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(width: 1, color: Colors.blueAccent)),
                                    /*child: Center(
                                      child: new IconButton(
                                          icon: Icon(Icons.send,size: 25,color: Colors.white,),
                                          onPressed: () => _sendMsg(
                                              _textController.text,
                                              'right',
                                              formattedDate)),
                                    ),*/
                                    child: GestureDetector(
                                      onTap: (){_sendMessage(widget.id+useruid[0],_textController.text);},
                                      child: Center(
                                        child: Padding(padding: EdgeInsets.only(left: 4),child: Icon(Icons.send,size: 24,color: Colors.white,)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                  ),
                ],
              ),
            )));
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




  Widget meBubble(message,name,time){
    return getSenderView(
        ChatBubbleClipper5(type: BubbleType.sendBubble), context,message,name,time);
  }

  /*Widget senderBubble(message){
    return getReceiverView(
        ChatBubbleClipper5(type: BubbleType.receiverBubble), context);
  }*/

  Widget senderBubble(message,name,time){

    return getReceiverView(
        ChatBubbleClipper3(type: BubbleType.receiverBubble), context,message,name,time);


    /*return Row(
      children: <Widget>[
        Container(
          height: 35,width: 35,
          color: Colors.white,margin: EdgeInsets.only(bottom: 55),

          child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
                depth: 8,
                lightSource: LightSource.topLeft,
                color: Colors.transparent
            ),
            child:  CachedNetworkImage(
              imageUrl: "https://wishnget.biz/rimages/c3.jpg",
              imageBuilder: (context, imageProvider) => Container(
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

        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 2),
              child: getReceiverView(
                  ChatBubbleClipper5(type: BubbleType.receiverBubble), context,message),
            )
          ],
        )
      ],
    );*/
  }


  getSenderView(CustomClipper clipper, BuildContext context,String message,String name,String time) => ChatBubble(
    clipper: clipper,
    alignment: Alignment.topRight,
    margin: EdgeInsets.only(top: 20),
    backGroundColor: Color(0xffE7E7ED),
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          text: '$message\n',
          children: <TextSpan>[
            TextSpan(text: time,style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    ),
  );

  getReceiverView(CustomClipper clipper, BuildContext context,message,name,time) => ChatBubble(
    clipper: clipper,
    backGroundColor: Colors.blueAccent,
    margin: EdgeInsets.only(top: 20),
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      /*child: Text(
        "Hi men how are you\n@mosedo ibrahim,22:59",
        style: TextStyle(color: Colors.white),
      ),*/
      child: RichText(
        text: TextSpan(
          text: '$message\n',
          children: <TextSpan>[
            TextSpan(text: '@$name',style: TextStyle(color: Colors.grey[400],fontSize: 10)),
            TextSpan(text: ',$time',style: TextStyle(color: Colors.grey[400],fontSize: 10)),
          ],
        ),
      ),
    ),
  );

  void _handleSubmitted(String text) {
    _textController.clear();
  }

  void _sendMessage(String id,String message) async{
    _textController.clear();

    List namelist=[];


    FirebaseUser user = await _firebaseAuth.currentUser();

    var datetime=new DateTime.now();
    var date=formatDate.format(datetime);
    var time=formatTime.format(datetime);



    var documentReference = Firestore.instance
        .collection('CounsellingRooms')
        .document(id);
    var roonsReference = Firestore.instance
        .collection('Rooms')
        .document(id);

    await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection("Users").document(useruid[0]).get().then((value){

      var v=value;

      documentReference.collection("messages").add(
          {
            'message': message,
            'sender': user.uid,
            'date': date,
            'time':time,
            'cousellor_avata':widget.image,
            'student_avata':widget.image,
            'name':value.data['name'],
            'type':'message',
            'created_at':DateTime.now()

          }).then((value){

        var documentReference = Firestore.instance
            .collection('Rooms')
            .document(id);


        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              'student': user.uid,
              'counsellor':widget.id
            },
          );
        }).then((value){
          Firestore.instance.collection("Rooms").document(widget.id+user.uid).get().then((value){
            Firestore.instance.collection("Users").document(value.data["student"]).get().then((student){
              Firestore.instance.collection("Users").document(value.data["counsellor"]).get().then((counsellor){
                Firestore.instance.runTransaction((transaction) async {
                  await transaction.update(
                    documentReference,
                    {
                      'student': user.uid,
                      'counsellor':widget.id,
                      'student_name':student.data["name"],
                      'student_image':student.data["image"],
                      'student_status':student.data["status"],
                      'student_campus':student.data["campus"],

                      'counsellor_name':counsellor.data["name"],
                      'counsellor_image':counsellor.data["image"],
                      'counsellor_status':counsellor.data["status"],
                      'counsellor_campus':counsellor.data["campus"],

                    },
                  );
                }).then((value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>RoomTwo(
                    id: widget.id,
                    name: widget.name,
                    image: widget.image,
                    status: widget.status,
                    counsellorid: widget.counselorid,
                    studentid: student,
                  )));
                });
              });
            });
          });
        });


        //scrolling code
      });

    });
  }

  Widget circularProgress(){
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            /*color: index.isEven ? Colors.blue : Colors.white,*/
              shape: BoxShape.circle,
              color: Colors.blueAccent
          ),
        );
      },
    );
  }

}

