import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_pickers/chat_pickers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:dio/dio.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:radauon/model/forummodel.dart';
import 'package:radauon/screens/image_viewer.dart';
import 'package:radauon/services/message.dart';
import 'package:radauon/utils/forum_helper.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../emoji_keyboard.dart';

class ForumRoom extends StatefulWidget {
  String id;
  String title;
  String image;

  ForumRoom({Key key, @required this.id, this.title, this.image})
      : super(key: key);

  @override
  _ForumRoomState createState() => _ForumRoomState();
}

class _ForumRoomState extends State<ForumRoom> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final List<Message> _messages = <Message>[];

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List useruid = [];

  ScrollController _scrollController = new ScrollController();

  var formatDate = new DateFormat("MMM d,yyyy");
  var formatTime = new DateFormat('EEEE, hh:mm aaa');

  bool canSend = false;
  String _messageText = '';
  bool _isShowSticker = false;

  FocusNode textFieldFocus = FocusNode();

  File _image;

  bool _showEmojiPicker = false;

  Dio dio = new Dio();

  double h = 0;

  String messager = "";
  String reply = "";
  String replytype = "";
  String replyimage = "";
  String messagetype = "wild";

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

  bool _progress = false;

  final _captionController = TextEditingController();

  // Event lastEvent;
  String lastConnectionState;
  Channel channel;

  var channelController = TextEditingController(text: "my-channel");
  var eventController = TextEditingController(text: "my-event");

  ForumHelper _forumHelper;

  bool _uploading = false;

  bool imagereply = false;

  //List<Map> _msglist = [];

  getThumb() async {
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: "",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          350, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    print(uint8list);
  }

  @override
  void initState() {
    super.initState();
    /*notifications();
    initializing();*/
    _forumHelper = ForumHelper();
    // initPusher();
    getNewMessages();
    //getThumb();
    setState(() {
      getId();
    });
  }

  Future<void> _startDownload(String savePath, String _fileUrl) async {
    print("File Path " + savePath.toString());
    final response = await dio.download(_fileUrl, savePath,
        onReceiveProgress: _onReceiveProgress);
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      _dprog = (received / total * 100).toStringAsFixed(0) + "%";
      //print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        //_progress = (received / total * 100).toStringAsFixed(0) + "%";
        setState(() {
          _dprog = (received / total * 100).toStringAsFixed(0) + "%";
        });
        //print((received / total * 100).toStringAsFixed(0) + "%");
      });
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    // if (Platform.isAndroid) {
    //   /*return await DownloadsPathProvider.downloadsDirectory;*/
    //   return await DownloadsPathProvider.downloadsDirectory;
    // }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

  void downLoadImage(String url, String imagename) async {
    /*var tempDir = await getTemporaryDirectory();
    var fullPath = tempDir.path + "/boo2.pdf'";
    print('full path ${fullPath}');*/

    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();
    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, imagename);
      await _startDownload(savePath, url);
      setState(() {
        progress = false;
        _dprog = "0";
      });
      //await download2(url, savePath);
    } else {
      // handle the scenario when user declines the permissions
    }

    //download2(url, fullPath);
  }

  /*showKeyboard() => textFieldFocus.toStringShallow();*/
  showKeyboard() => SystemChannels.textInput.invokeMethod('TextInput.show');
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

  uploadToFirebase(String url, String type, int size, String name, String thumb,
      String caption, PlatformFile file) async {
    setState(() {
      _uploading = true;
    });

    var documentReference =
        Firestore.instance.collection('ForumRooms').document(widget.id);

    FirebaseUser user = await _firebaseAuth.currentUser();

    var datetime = new DateTime.now();
    var date = formatDate.format(datetime);
    var time = formatTime.format(datetime);

    var messagetime = DateTime.now().millisecondsSinceEpoch.toString();

    await Firestore.instance
        .collection("Users")
        .document(useruid[0])
        .get()
        .then((value) async {
      var v = value;

      await _forumHelper.save({
        'message': caption,
        'sender_id': useruid[0],
        'sender_name': value.data['name'],
        'size': size.toString(),
        'student_avata': widget.image,
        'filename': name,
        'thumb': thumb,
        'url': url,
        'title': widget.title,
        'type': type,
        'imagename': name,
        'status': "sending",
        'reply': "",
        'caption': caption,
        'channel': widget.id,
        'created_at': date.toString(),
        'time': messagetime,
      }).then((value1) {
        setState(() {});
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            curve: Curves.easeOut, duration: const Duration(milliseconds: 300));

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
        }).then((value2) async {
          http.Response response = await http
              .post('http://rada.uonbi.ac.ke/radaweb/api/message', headers: {
            "Accept": "application/json"
          }, body: {
            'message': caption,
            'sender_id': useruid[0],
            'sender_name': value.data['name'],
            'size': size.toString(),
            'student_avata': widget.image,
            'filename': name,
            'thumb': thumb,
            'url': url,
            'title': widget.title,
            'type': type,
            'imagename': name,
            'status': "sending",
            'reply': "",
            'caption': caption,
            'channel': widget.id,
            'time': messagetime,
          });
          print(response.body);
          setState(() {
            _uploading = false;
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          });
        });
      });
    });
  }

  Future<void> initPusher() async {
    try {
      await Pusher.init("f46cd4f7b5bf8ccbe238", PusherOptions(cluster: "ap2"),
          enableLogging: true);
    } on PlatformException catch (e) {
      print(e.message);
    }
    await Pusher.connect(onConnectionStateChange: (res) {
      print("Current state is " + res.currentState);
    }, onError: (msg) {
      print(msg.message);
    });

    //subscribe
    channel = await Pusher.subscribe("chat");

    //bind
    channel.bind("chat_event", (msg) async {
      setState(() {});
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
      var convert = await json.decode(msg.data);
      if (convert["sender_id"] != useruid[0]) {
        await _forumHelper.save({
          'message': convert["message"],
          'sender_id': convert["sender_id"],
          'sender_name': convert["sender_name"],
          'size': convert["size"],
          'student_avata': convert["student_avata"],
          'filename': convert["filename"],
          'thumb': convert["thumb"],
          'url': convert["url"],
          'title': convert["title"],
          'type': convert["type"],
          'imagename': convert["imagename"],
          'status': convert["status"],
          'reply': convert["reply"],
          'caption': convert["caption"],
          'channel': convert["channel"],
          'time': convert["time"],
        }).then((value) {
          setState(() {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          });
          //print("Message saved");
        });
      }
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
          /*"https://mysitemose.000webhostapp.com/uploads.php",*/
          "http://rada.uonbi.ac.ke/radax/uploads.php",
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

        Response thumbresponse = await Dio()
            .post("http://rada.uonbi.ac.ke/radax/uploads.php", data: thumbData);
        uploadToFirebase(
            response.data, type, size, name, thumbresponse.data, caption, file);
      } else if (type == "image") {
        uploadToFirebase(
            response.data, type, size, name, response.data, caption, file);
      } else if (type == "docx") {
        uploadToFirebase(
            response.data, type, size, name, response.data, caption, file);
      } else if (type == "pdf") {
        uploadToFirebase(
            response.data, type, size, name, response.data, caption, file);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildImageComposer() {
    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.fromLTRB(7, 0, 7, 3),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 0),
              height: 50,
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
                  height: 50,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Upload file")),
                  ),
                  /*child: TextField(
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
                  ),*/
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
                      setState(() {
                        _uploading = true;
                      });
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
                      Material(
                        child: InkWell(
                          child: Icon(Icons.camera_alt,
                              color: Colors.grey[600], size: 24),
                          onTap: () {
                            _imagePicker();
                          },
                        ),
                      ),
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
                /*_sendMessage(widget.id, _textController.text);*/
                _sendMyMessage(widget.id, _textController.text);
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

  void _addGifMessage(/*GiphyGif gif*/) {
    /*PhotoMessage message = PhotoMessage(
      isGif: true,
      url: gif.images.original.url,
      senderId: widget.myUid,
      time: DateTime.now(),
    );

    _chatStore.addMessage(message);*/
  }

  void _sendMyMessage(String room, String message) async {
    print("Image: " + replyimage);
    _textController.clear();
    //replyimage = "";
    setState(() {
      h = 0;
    });

    List namelist = [];

    FirebaseUser user = await _firebaseAuth.currentUser();

    var datetime = new DateTime.now();
    var date = formatDate.format(datetime);
    var time = formatTime.format(datetime);

    var documentReference =
        Firestore.instance.collection('ForumRooms').document(widget.id);
    var roonsReference =
        Firestore.instance.collection('Rooms').document(widget.id);

    var messagetime = DateTime.now().millisecondsSinceEpoch.toString();

    await FirebaseAuth.instance.currentUser();
    if (messagetype == "wild") {
      await Firestore.instance
          .collection("Users")
          .document(useruid[0])
          .get()
          .then((value) async {
        await _forumHelper.save({
          'message': message,
          'sender_id': useruid[0],
          'sender_name': value.data['name'],
          'size': "0",
          'student_avata': widget.image,
          'filename': "",
          'thumb': "",
          'url': "",
          'title': widget.title,
          'type': "message",
          'imagename': "",
          'status': "sending",
          'reply': "",
          'caption': "",
          'channel': widget.id,
          'created_at': date.toString(),
          'time': messagetime,
        }).then((value1) {
          setState(() {});
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );

          documentReference.collection("messages").add({
            'message': message,
            'sender': user.uid,
            'date': date,
            'time': time,
            'cousellor_avata': widget.image,
            'student_avata': widget.image,
            'name': value.data['name'],
            'type': 'message',
            'title': widget.title,
            'created_at': DateTime.now()
          }).then((value2) async {
            textFieldFocus.unfocus();
            _showEmojiPicker = false;
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
            http.Response response =
                await http.post('http://rada.uonbi.ac.ke/radaweb/api/message',
                    /*'http://192.168.8.103/LaravelPusher/public/api/message',*/
                    headers: {
                  "Accept": "application/json"
                }, body: {
              'message': message,
              'sender_id': useruid[0],
              'sender_name': value.data['name'],
              'size': "0",
              'student_avata': widget.image,
              'filename': "",
              'thumb': "",
              'url': "",
              'title': widget.title,
              'type': "message",
              'imagename': "",
              'status': "sending",
              'reply': "",
              'caption': "",
              'channel': widget.id,
              'time': messagetime,
            });

            print(response.body);
          });
        });
      });
    } else if (messagetype == "reply") {
      //print("Image is: " + replyimage);
      print("Running here");
      await Firestore.instance
          .collection("Users")
          .document(useruid[0])
          .get()
          .then((value) async {
        await _forumHelper.save({
          'message': message,
          'sender_id': useruid[0],
          'sender_name': value.data['name'],
          'size': "0",
          'student_avata': widget.image,
          'filename': "",
          'thumb': replyimage,
          'url': replyimage,
          'title': widget.title,
          'type': "reply",
          'imagename': "",
          'status': "sending",
          'reply': reply,
          'caption': "",
          'channel': widget.id,
          'created_at': date.toString(),
          'time': messagetime,
        }).then((value1) {
          setState(() {});
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );

          documentReference.collection("messages").add({
            'message': message,
            'sender': user.uid,
            'date': date,
            'time': time,
            'cousellor_avata': widget.image,
            'student_avata': widget.image,
            'name': value.data['name'],
            'type': 'reply',
            'reply': reply,
            'title': widget.title,
            'created_at': DateTime.now()
          }).then((value2) async {
            setState(() {
              messagetype = "wild";
              imagereply = false;
            });
            http.Response response =
                await http.post('http://rada.uonbi.ac.ke/radaweb/api/message',
                    /*'http://192.168.8.103/LaravelPusher/public/api/message',*/
                    headers: {
                  "Accept": "application/json"
                }, body: {
              'message': message,
              'sender_id': useruid[0],
              'sender_name': value.data['name'],
              'size': "0",
              'student_avata': widget.image,
              'filename': "",
              'thumb': replyimage,
              'url': replyimage,
              'title': widget.title,
              'type': "reply",
              'imagename': "",
              'status': "sending",
              'reply': "",
              'caption': "",
              'channel': widget.id,
              'time': messagetime,
            });

            setState(() {});
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );

            print(response.body);
            //scrolling code
          });
        });
      });
    }
  }

  Widget meImage(
      String url,
      String imagename,
      String name,
      String time,
      String sender,
      /*AsyncSnapshot<QuerySnapshot> snapshot,*/
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
                        borderRadius: BorderRadius.circular(0),
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
      /*AsyncSnapshot<QuerySnapshot> snapshot,*/
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
          /*_snap = snapshot;*/
        });
        Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            _share = false;
          });
        });
      },
      child: Stack(
        children: [
          Padding(
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
                            borderRadius: BorderRadius.circular(0),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*Positioned(
            bottom: 15,
            left: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: !_progress
                  ? GestureDetector(
                      onTap: () {
                        _progress = true;
                        _saveNetworkImage(url.trim());
                      },
                      child: Container(
                        color: Colors.black.withAlpha(200),
                        height: 40,
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "0.9MB",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.black.withAlpha(200),
                      height: 40,
                      width: 80,
                      child: Center(
                        child: CircularProgressIndicator(),
                      )),
            ),
          ),*/
        ],
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
      /*AsyncSnapshot<QuerySnapshot> snapshot,*/
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
      /*onLongPress: () {
        setState(() {
          _share = true;
          _type = "image";
          _imageurl = url;
          _index = index;
          */ /*_snap = snapshot;*/ /*
        });
        Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            _share = false;
          });
        });
      },*/
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
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(0),
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
      /*AsyncSnapshot<QuerySnapshot> snapshot,*/
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
          /*_snap = snapshot;*/
        });
        Future.delayed(const Duration(milliseconds: 3000), () {
          setState(() {
            _share = false;
          });
        });
      },
      child: Stack(
        children: [
          Padding(
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
                                borderRadius: BorderRadius.circular(0),
                                child: Stack(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                        imageUrl: thumb.trim(),
                                        imageBuilder: (context,
                                                imageProvider) =>
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
          /*Positioned(
            bottom: 15,
            left: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: !_progress
                  ? GestureDetector(
                      onTap: () {
                        _progress = true;
                        _saveNetworkVideo(url.trim());
                      },
                      child: Container(
                        color: Colors.black.withAlpha(200),
                        height: 40,
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "0.9MB",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.black.withAlpha(200),
                      height: 40,
                      width: 80,
                      child: Center(
                        child: CircularProgressIndicator(),
                      )),
            ),
          ),*/
        ],
      ),
    );
  }

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final _textController = TextEditingController();
  final _searchController = TextEditingController();

  Widget messageReply(
      String message, String name, String type, String reply, String sender) {
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
                      child: Text(reply),
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
                    Container(
                      child: Text(reply),
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

  Widget chatBubble(
      String message,
      String sender,
      String name,
      String type,
      int index,
      /*AsyncSnapshot<QuerySnapshot> snapshot,
      DocumentSnapshot documentSnapshot,*/
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

  Widget _showMenu() {
    return AnimatedContainer(
      width: MediaQuery.of(context).size.width,
      height: !_share ? 0 : 60,
      color: Colors.grey[100],
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 700),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.inbox,
                color: Colors.green,
              )),
          GestureDetector(
            onTap: () {
              if (_type == "image") {
                _shareImageFromUrl("");
              } else {
                _shareText("");
              }
            },
            child: Icon(
              Icons.share,
              color: Colors.blue,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  //_doc.re
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //assetsAudioPlayer.open(Audio('assets/images/note.mp3'), autoStart: true);
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
                  child: !search
                      ? Row(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
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
                            /*GestureDetector(
                              onTap: () {
                                setState(() {
                                  search = true;
                                });
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.grey.shade700,
                                size: 30,
                              ),
                            ),*/
                            _uploading
                                ? Loading(
                                    indicator: BallPulseIndicator(),
                                    size: 30.0,
                                    color: Colors.blue)
                                : SizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                          ],
                        )
                      : AnimatedContainer(
                          height: 60,
                          width:
                              !search ? 0 : MediaQuery.of(context).size.width,
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 700),
                          color: Colors.grey[100],
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      search = false;
                                    });
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 3),
                                      child: Icon(Icons.cancel))),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search message...",
                                      hintStyle:
                                          TextStyle(color: Colors.black)),
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ):AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey[100],
              flexibleSpace: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: !search
                      ? Row(
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
                              style:
                              TextStyle(fontWeight: FontWeight.w600),
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
                      /*GestureDetector(
                              onTap: () {
                                setState(() {
                                  search = true;
                                });
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.grey.shade700,
                                size: 30,
                              ),
                            ),*/
                      _uploading
                          ? Loading(
                          indicator: BallPulseIndicator(),
                          size: 30.0,
                          color: Colors.blue)
                          : SizedBox(
                        height: 0,
                        width: 0,
                      ),
                    ],
                  )
                      : AnimatedContainer(
                    height: 60,
                    width:
                    !search ? 0 : MediaQuery.of(context).size.width,
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 700),
                    color: Colors.grey[100],
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                search = false;
                              });
                            },
                            child: Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: Icon(Icons.cancel))),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search message...",
                                hintStyle:
                                TextStyle(color: Colors.black)),
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      //Chat list

                      Column(
                        children: [
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                          ),
                          replyWidget()
                        ],
                      ),
                      //_showMenu(),

                      Expanded(
                        flex: 7,
                        child: Container(
                          child: FutureBuilder(
                            builder: (context, projectSnap) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(3, 5, 3, 2),
                                child: ListView.builder(
                                  reverse: false,
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: projectSnap.data == null
                                      ? 0
                                      : projectSnap.data.length,
                                  itemBuilder: (_, int index) {
                                    /*_forumHelper.deleteAll();*/
                                    ForumModel project =
                                        projectSnap.data[index];

                                    print(project.url.runtimeType);

                                    final dynamic msg = project.message;
                                    final dynamic d = project.time;
                                    final dynamic t = project.time;
                                    final dynamic sender = project.sender_id;
                                    final dynamic name = project.sender_name;
                                    final dynamic type = project.type;

                                    if (type == "message" &&
                                        project.channel == widget.id) {
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
                                              showKeyboard();
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
                                              showKeyboard();
                                            });
                                          },
                                          //child: meBubble(msg, name, t),
                                          child: FocusedMenuHolder(
                                            menuWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            blurSize: 5.0,
                                            menuItemExtent: 45,
                                            menuBoxDecoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0))),
                                            duration:
                                                Duration(milliseconds: 100),
                                            animateMenuItems: true,
                                            blurBackgroundColor: Colors.black54,
                                            menuOffset:
                                                10.0, // Offset value to show menuItem from the selected item
                                            bottomOffsetHeight:
                                                80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
                                            menuItems: <FocusedMenuItem>[
                                              // Add Each FocusedMenuItem  for Menu Options
                                              FocusedMenuItem(
                                                  title: Text("Share"),
                                                  trailingIcon:
                                                      Icon(Icons.share),
                                                  onPressed: () {
                                                    print(project.reply);
                                                    _shareText(project.message);
                                                  }),

                                              FocusedMenuItem(
                                                  title: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                                  trailingIcon: Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed: () {
                                                    _forumHelper
                                                        .delete(project.time)
                                                        .then((value) {
                                                      setState(() {});
                                                      deleteMessage(project.time
                                                          .toString());
                                                    });
                                                  }),
                                            ],
                                            child: chatBubble(
                                                msg,
                                                sender,
                                                name,
                                                type,
                                                index,
                                                /*snapshot,
                                                document,*/
                                                time.toString()),
                                          ),
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
                                                /*snapshot,
                                                document,*/
                                                project.created_at.toString()));
                                      }

                                      //return senderBubble(msg,name,t);
                                    } else if (type == 'image' &&
                                        project.channel == widget.id) {
                                      //return meImage(document['url']);

                                      if (project.sender_id == useruid[0]) {
                                        return FocusedMenuHolder(
                                          menuWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.50,
                                          blurSize: 5.0,
                                          menuItemExtent: 45,
                                          menuBoxDecoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          duration: Duration(milliseconds: 100),
                                          animateMenuItems: true,
                                          blurBackgroundColor: Colors.black54,
                                          menuOffset:
                                              10.0, // Offset value to show menuItem from the selected item
                                          bottomOffsetHeight: 80.0,
                                          menuItems: <FocusedMenuItem>[
                                            // Add Each FocusedMenuItem  for Menu Options
                                            FocusedMenuItem(
                                                title: Text("Open"),
                                                trailingIcon:
                                                    Icon(Icons.open_in_new),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImageView(
                                                              url: project.url,
                                                              type: "image",
                                                            )),
                                                  );
                                                }),
                                            FocusedMenuItem(
                                                title: Text("Share"),
                                                trailingIcon: Icon(Icons.share),
                                                onPressed: () {
                                                  //print(project.url);
                                                  _shareImageFromUrl(project.url
                                                      .toString()
                                                      .trim());
                                                }),

                                            FocusedMenuItem(
                                                title: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.redAccent),
                                                ),
                                                trailingIcon: Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    progress = true;
                                                  });
                                                  _forumHelper
                                                      .delete(project.time)
                                                      .then((value) {
                                                    setState(() {});
                                                    setState(() {
                                                      progress = false;
                                                    });
                                                    deleteMessage(project.time);
                                                    /*print("Returned: " +
                                                        value.toString());*/
                                                  });
                                                }),
                                          ],
                                          onPressed: () {},
                                          child: SwipeTo(
                                            swipeDirection:
                                                SwipeDirection.swipeToLeft,
                                            endOffset: Offset(0.3, 0.0),
                                            callBack: () {
                                              //print(project.url);
                                              setState(() {
                                                messager = name;
                                                reply = msg;
                                                replytype = type;
                                                replyimage = project.url;
                                                messagetype = "reply";
                                                imagereply = true;
                                                h = 55;
                                                showKeyboard();
                                              });
                                            },
                                            child: meImage(
                                                project.url,
                                                project.imagename,
                                                project.sender_name,
                                                project.created_at,
                                                project.sender_id,
                                                /*snapshot,*/
                                                index,
                                                type),
                                          ),
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
                                              replyimage = project.url;
                                              messagetype = "reply";
                                              h = 55;
                                              imagereply = true;
                                              showKeyboard();
                                            });
                                          },
                                          child: senderImage(
                                              project.url,
                                              project.imagename,
                                              project.sender_name,
                                              project.created_at,
                                              project.sender_id,
                                              /*snapshot,*/
                                              index,
                                              type),
                                        );
                                      }
                                    } else if (type == "reply" &&
                                        project.channel == widget.id) {
                                      if (sender == useruid[0]) {
                                        return SwipeGestureRecognizer(
                                            onSwipeLeft: () {
                                              setState(() {
                                                messager = name;
                                                reply = msg;
                                                replytype = type;
                                                replyimage = "";
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
                                                h = 55;
                                              });
                                              //print(replytype);
                                            },
                                            child:
                                                /*project.url == ""
                                              ? */
                                                SwipeTo(
                                              swipeDirection:
                                                  SwipeDirection.swipeToLeft,
                                              endOffset: Offset(-0.3, 0.0),
                                              callBack: () {
                                                setState(() {
                                                  messager = name;
                                                  reply = msg;
                                                  replytype = type;
                                                  replyimage = project.url;
                                                  h = 55;
                                                  messagetype = "reply";
                                                  showKeyboard();
                                                });
                                              },
                                              child: FocusedMenuHolder(
                                                menuWidth:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.50,
                                                blurSize: 5.0,
                                                menuItemExtent: 45,
                                                menuBoxDecoration:
                                                    BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                duration:
                                                    Duration(milliseconds: 100),
                                                animateMenuItems: true,
                                                blurBackgroundColor:
                                                    Colors.black54,
                                                menuOffset:
                                                    10.0, // Offset value to show menuItem from the selected item
                                                bottomOffsetHeight: 80.0,
                                                menuItems: <FocusedMenuItem>[
                                                  // Add Each FocusedMenuItem  for Menu Options
                                                  FocusedMenuItem(
                                                      title: Text("Share"),
                                                      trailingIcon:
                                                          Icon(Icons.share),
                                                      onPressed: () {
                                                        //print(project.url);
                                                        _shareText(
                                                            project.message);
                                                      }),

                                                  FocusedMenuItem(
                                                      title: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                      trailingIcon: Icon(
                                                        Icons.delete,
                                                        color: Colors.redAccent,
                                                      ),
                                                      onPressed: () {
                                                        _forumHelper
                                                            .delete(
                                                                project.time)
                                                            .then((value) {
                                                          setState(() {});
                                                          deleteMessage(
                                                              project.time);
                                                        });
                                                      }),
                                                ],
                                                child: meReply(
                                                    msg,
                                                    name,
                                                    project.created_at,
                                                    project.reply,
                                                    project.url,
                                                    project.thumb),
                                              ),
                                            )
                                            /*: SwipeTo(
                                                  swipeDirection: SwipeDirection
                                                      .swipeToRight,
                                                  endOffset: Offset(0.3, 0.0),
                                                  callBack: () {
                                                    setState(() {
                                                      messager = name;
                                                      reply = msg;
                                                      replytype = type;
                                                      replyimage = project.url;
                                                      messagetype = "reply";
                                                      h = 55;
                                                    });
                                                  },
                                                  child: replymeImage(sender,
                                                      project.url, msg, name),
                                                ),*/
                                            );
                                      } else {
                                        return SwipeGestureRecognizer(
                                            onSwipeLeft: () {
                                              setState(() {
                                                messager = name;
                                                reply = msg;
                                                replytype = type;
                                                replyimage = "";
                                                h = 55;
                                                messagetype = "reply";
                                              });
                                              print(replytype);
                                            },
                                            onSwipeRight: () {
                                              setState(() {
                                                messager = name;
                                                reply = msg;
                                                replytype = type;
                                                replyimage = "";
                                                h = 55;
                                                messagetype = "reply";
                                              });
                                              print(replytype);
                                            },
                                            child: SwipeTo(
                                              swipeDirection:
                                                  SwipeDirection.swipeToRight,
                                              endOffset: Offset(-0.3, 0.0),
                                              callBack: () {
                                                setState(() {
                                                  messager = name;
                                                  reply = msg;
                                                  replytype = type;
                                                  replyimage = project.url;
                                                  h = 55;
                                                  messagetype = "reply";
                                                  showKeyboard();
                                                });
                                              },
                                              child: senderReply(
                                                  msg,
                                                  name,
                                                  project.created_at.toString(),
                                                  project.reply,
                                                  project.thumb),
                                            ));
                                        /*child: messageReply(msg, name, t,
                                              document['reply'], sender));*/
                                      }
                                    } else if (type == "video" &&
                                        project.channel == widget.id) {
                                      if (sender == useruid[0]) {
                                        return SwipeTo(
                                          swipeDirection:
                                              SwipeDirection.swipeToLeft,
                                          endOffset: Offset(0.3, 0.0),
                                          callBack: () {
                                            //print(project.url);
                                            setState(() {
                                              messager = name;
                                              reply = msg;
                                              replytype = type;
                                              replyimage = project.thumb;
                                              messagetype = "reply";
                                              imagereply = true;
                                              h = 55;
                                              showKeyboard();
                                            });
                                          },
                                          child: FocusedMenuHolder(
                                            menuWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            blurSize: 5.0,
                                            menuItemExtent: 45,
                                            menuBoxDecoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0))),
                                            duration:
                                                Duration(milliseconds: 100),
                                            animateMenuItems: true,
                                            blurBackgroundColor: Colors.black54,
                                            menuOffset:
                                                10.0, // Offset value to show menuItem from the selected item
                                            bottomOffsetHeight: 80.0,
                                            menuItems: <FocusedMenuItem>[
                                              // Add Each FocusedMenuItem  for Menu Options
                                              /*FocusedMenuItem(
                                                  title: Text("Open"),
                                                  trailingIcon:
                                                      Icon(Icons.open_in_new),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ImageView(
                                                                url:
                                                                    project.url,
                                                                type: "image",
                                                              )),
                                                    );
                                                  }),*/

                                              FocusedMenuItem(
                                                  title: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                                  trailingIcon: Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed: () {
                                                    print(project.time);
                                                    _forumHelper
                                                        .delete(project.time)
                                                        .then((value) {
                                                      setState(() {});
                                                      deleteMessage(
                                                          project.time);
                                                    });
                                                  }),
                                            ],
                                            onPressed: () {},
                                            child: meVideo(
                                              project.url,
                                              project.thumb,
                                              project.filename,
                                              project.sender_name,
                                              project.created_at.toString(),
                                              project.sender_id,
                                              index,
                                              project.type,
                                              project.caption,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SwipeTo(
                                          swipeDirection:
                                              SwipeDirection.swipeToRight,
                                          endOffset: Offset(0.3, 0.0),
                                          callBack: () {
                                            //print(project.url);
                                            setState(() {
                                              messager = name;
                                              reply = msg;
                                              replytype = type;
                                              replyimage = project.thumb;
                                              messagetype = "reply";
                                              imagereply = true;
                                              h = 55;
                                              showKeyboard();
                                            });
                                          },
                                          child: senderVideo(
                                              project.url,
                                              project.thumb,
                                              project.filename,
                                              project.sender_name,
                                              project.created_at.toString(),
                                              sender,
                                              index,
                                              project.type),
                                        );
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
                            future: getProjectDetails(),
                          ),

                          /* child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('ForumRooms')
                              .document(widget.id)
                              .collection("messages")
                              .orderBy('created_at', descending: false)
                              */ /*.limit(20)*/ /*
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            SchedulerBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            });

                            if (!snapshot.hasData) {
                              return Center(
                                child: circularProgress(),
                              );
                            }
                            var messageCount = snapshot.data.documents.length;
                            return messageBuider();
                          },
                        )*/
                        ),
                      ),

                      //chat list end

                      Padding(
                          padding:
                              EdgeInsets.only(right: 10, left: 10, bottom: 10),
                          child: !_show
                              ? _buildMessageComposer()
                              : _buildImageComposer()),
                      EmojiContainer(),

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

  Widget replyWidget() {
    return replytype == "image"
        ? ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0), topRight: Radius.circular(0.0)),
            child: AnimatedContainer(
              width: MediaQuery.of(context).size.width,
              height: h,
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Row(
                        children: [
                          Text(
                            "Replying to.",
                            style: TextStyle(
                              color: Colors.green[400],
                            ),
                          ),
                          Text(
                            "$messager",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      top: 7,
                      left: 5,
                    ),
                    Positioned(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                      ),
                      top: 25,
                    ),
                    Positioned(
                      child: Text(
                        "Image",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      top: 30,
                      left: 30,
                    ),
                    Positioned(
                      right: 0,
                      top: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 45,
                          width: 45,
                          color: Colors.white,
                          child: CachedNetworkImage(
                            imageUrl: replyimage,
                            imageBuilder: (context, imageProvider) => Container(
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
                            errorWidget: (context, url, error) => Center(
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
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.redAccent.withAlpha(150),
                              shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              'x',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      right: 7,
                      top: 10,
                    ),
                  ],
                ),
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0.0), topRight: Radius.circular(0.0)),
            child: AnimatedContainer(
              width: MediaQuery.of(context).size.width,
              height: h,
              curve: Curves.easeInCubic,
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Row(
                        children: [
                          Text(
                            "Replying to.",
                            style: TextStyle(
                              color: Colors.green[400],
                            ),
                          ),
                          Text(
                            "$messager",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      top: 7,
                      left: 5,
                    ),
                    Positioned(
                      child: reply.length > 35
                          ? Text(
                              reply.substring(0, 35) + "...",
                              style: TextStyle(color: Colors.black),
                            )
                          : Text(
                              reply,
                              style: TextStyle(color: Colors.black),
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
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              color: Colors.redAccent, shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              '-',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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

  void _filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );
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
    }

    /*try {
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
      }
    } catch (e) {
      print("something went wrong");
    }*/
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
              color: Colors.blueAccent),
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
        Firestore.instance.collection('ForumRooms').document(widget.id);
    var roonsReference =
        Firestore.instance.collection('Rooms').document(widget.id);

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
          'cousellor_avata': widget.image,
          'student_avata': widget.image,
          'name': value.data['name'],
          'type': 'message',
          'title': widget.title,
          'created_at': DateTime.now()
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
          'cousellor_avata': widget.image,
          'student_avata': widget.image,
          'name': value.data['name'],
          'type': 'reply',
          'reply': reply,
          'title': widget.title,
          'created_at': DateTime.now()
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

  Future<void> _shareImage() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/image1.png');
      await Share.file(
          'esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/png',
          text: 'My optional text.');
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareText(String text) async {
    try {
      Share.text('Share to', text, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImageFromUrl(String url) async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('Share to', 'amlog.jpg', bytes, 'image/jpg');
    } catch (e) {
      print('error: $e');
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

  Widget meReply(message, name, time, reply, url, thumb) {
    return getSenderReply(ChatBubbleClipper4(type: BubbleType.sendBubble),
        context, message, name, time, reply, url, thumb);
  }

  Widget senderReply(message, name, time, reply, thumb) {
    return getReceiverReply(ChatBubbleClipper4(type: BubbleType.receiverBubble),
        context, message, name, time, reply, thumb);
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
          String name, String time, reply, url, thumb) =>
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
                          reply != ""
                              ? Text(
                                  reply.length <= 70
                                      ? reply.toString()
                                      : reply.toString().substring(0, 70) +
                                          "...",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w700),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ImageView(
                                                    url: thumb,
                                                    type: "image",
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        color: Colors.grey[100],
                                        height: 40,
                                        width: 40,
                                        child: Image.network(
                                          thumb,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("File message"),
                                      ],
                                    )
                                  ],
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

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  getReceiverReply(CustomClipper clipper, BuildContext context, message, name,
          time, reply, thumb) =>
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
                          reply != ""
                              ? Text(
                                  reply.length <= 70
                                      ? reply.toString()
                                      : reply.toString().substring(0, 70) +
                                          "...",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w700),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ImageView(
                                                    url: thumb,
                                                    type: "image",
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        color: Colors.grey[100],
                                        height: 40,
                                        width: 40,
                                        child: Image.network(
                                          thumb,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("File message"),
                                      ],
                                    )
                                  ],
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
                    "$time",
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
  void _saveNetworkVideo(String url) async {
    await GallerySaver.saveVideo(url).then((bool success) {
      print('Video is saved');
    });
  }

  void _saveNetworkImage(String url) async {
    await GallerySaver.saveImage(url).then((bool success) {
      setState(() {
        _progress = false;
      });
      //print('Image is saved');
    });
  }

  Future getProjectDetails() async {
    List<ForumModel> recs = await _forumHelper.getMessages();
    /*recs.forEach((element) {
      print(element.sender_id);
    });*/
    return recs;
  }

  Future getNewMessages() async {
    List<ForumModel> recs = await _forumHelper.getMessages();
    if (recs.length > 0) {
      http.Response response =
          await http.post('http://rada.uonbi.ac.ke/radaweb/api/getmessages',
              /*'http://192.168.8.103/LaravelPusher/public/api/getmessages',*/
              headers: {"Accept": "application/json"},
              /*body: {'time': recs[recs.length - 1].time});*/
              body: {'time': recs[recs.length - 1].time});

      print(response.body);

      var convert = await json.decode(response.body);

      if (convert.length > 0) {
        for (var i = 0; i < convert.length; i++) {
          await _forumHelper.save({
            'message': convert[i]["message"],
            'sender_id': convert[i]["sender_id"],
            'sender_name': convert[i]["sender_name"],
            'size': convert[i]["size"],
            'student_avata': convert[i]["student_avata"],
            'filename': convert[i]["filename"],
            'thumb': convert[i]["thumb"],
            'url': convert[i]["url"],
            'title': convert[i]["title"],
            'type': convert[i]["type"],
            'imagename': convert[i]["imagename"],
            'status': convert[i]["status"],
            'reply': convert[i]["reply"],
            'caption': convert[i]["caption"],
            'channel': convert[i]["channel"],
            'created_at': DateTime.now().toString(),
            'time': convert[i]["time"],
          }).then((value) {
            setState(() {});
            /*_scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300));*/
          });

          /*if (convert[i]["type"] == "delete" &&
              convert[i]["sender_id"] != useruid[0]) {
            _forumHelper.delete(convert[i]["message"]).then((value) {
              setState(() {});
            });
          } else {
            await _forumHelper.save({
              'message': convert[i]["message"],
              'sender_id': convert[i]["sender_id"],
              'sender_name': convert[i]["sender_name"],
              'size': convert[i]["size"],
              'student_avata': convert[i]["student_avata"],
              'filename': convert[i]["filename"],
              'thumb': convert[i]["thumb"],
              'url': convert[i]["url"],
              'title': convert[i]["title"],
              'type': convert[i]["type"],
              'imagename': convert[i]["imagename"],
              'status': convert[i]["status"],
              'reply': convert[i]["reply"],
              'caption': convert[i]["caption"],
              'channel': convert[i]["channel"],
              'time': convert[i]["time"],
            }).then((value) {
              setState(() {});
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300));
            });
          }*/
        }
      } else {
        /*_scrollController.animateTo(_scrollController.position.maxScrollExtent,
            curve: Curves.easeOut, duration: const Duration(milliseconds: 300));*/
      }
    } else {
      http.Response response =
          await http.post('http://rada.uonbi.ac.ke/radaweb/api/getallmessages',
              /*'http://192.168.8.103/LaravelPusher/public/api/getmessages',*/
              headers: {"Accept": "application/json"}, body: {'time': "0"});

      print(response.body);

      var convert = await json.decode(response.body);

      if (convert.length > 0) {
        for (var i = 0; i < convert.length; i++) {
          await _forumHelper.save({
            'message': convert[i]["message"],
            'sender_id': convert[i]["sender_id"],
            'sender_name': convert[i]["sender_name"],
            'size': convert[i]["size"],
            'student_avata': convert[i]["student_avata"],
            'filename': convert[i]["filename"],
            'thumb': convert[i]["thumb"],
            'url': convert[i]["url"],
            'title': convert[i]["title"],
            'type': convert[i]["type"],
            'imagename': convert[i]["imagename"],
            'status': convert[i]["status"],
            'reply': convert[i]["reply"],
            'caption': convert[i]["caption"],
            'channel': convert[i]["channel"],
            'created_at': DateTime.now().toString(),
            'time': convert[i]["time"],
          }).then((value) {
            setState(() {});
            /*_scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300));*/
          });
        }
      } else {
        /*_scrollController.animateTo(_scrollController.position.maxScrollExtent,
            curve: Curves.easeOut, duration: const Duration(milliseconds: 300));*/
      }
    }

    return recs;
  }

  void deleteMessage(String message_id) async {
    http.Response response =
        await http.post('http://rada.uonbi.ac.ke/radaweb/api/delete',
            /*'http://192.168.8.103/LaravelPusher/public/api/delete',*/
            headers: {
          "Accept": "application/json"
        }, body: {
      'message_id': message_id,
    });
  }
}
