import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:radauon/screens/password_reset.dart';

class ProfilePage extends StatefulWidget {
  var id;

  ProfilePage({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map> profile_data = [];

  final _nameController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool checked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  Future<void> _uploadFile(PlatformFile file) async {
    String fileName = file.name;

    try {
      FormData formData = new FormData.fromMap({
        "name": "rajika",
        "age": 22,
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Uploading, please wait...."),
        backgroundColor: Colors.green,
      ));

      Response response = await Dio()
          .post("http://rada.uonbi.ac.ke/radax/uploadprofile.php", data: formData);

      changeImage(response.data);
    } catch (e) {
      print(e);
    }
  }

  void _imagePicker() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Working, please wait...."),
          backgroundColor: Colors.blue,
        ));
        _uploadFile(file);
      }
    } catch (e) {
      print("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: Platform.isIOS?AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ):AppBar(
        backgroundColor: Colors.grey[100],
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
      body: profile_data.length <= 0
          ? Center(
              child: circularProgress(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.white])),
                      child: Container(
                        width: double.infinity,
                        height: 300.0,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(profile_data[
                                                0]["image"] ==
                                            null
                                        ? "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png"
                                        : profile_data[0]["image"]),
                                    radius: 50.0,
                                  ),
                                  Positioned(
                                    bottom: 3,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        _imagePicker();
                                      },
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 35,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                profile_data[0]["name"],
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 0.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                elevation: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0, vertical: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "University",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              profile_data[0]["university"],
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.green[400],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Campus",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              profile_data[0]["campus"],
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.green[400],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Sex",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              profile_data[0]["gender"],
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.green[400],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: TextField(
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                              controller: _nameController,
                              obscureText: false,
                              cursorWidth: 3.0,
                              cursorColor: Colors.red,
                              onChanged: (val) {
                                setState(() {
                                  checked = true;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                hintText: 'Username',
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                contentPadding: const EdgeInsets.only(
                                    top: 18, bottom: 18, left: 15, right: 15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[100]),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[100]),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                //labelText: 'Password',
                              ),
                            ),
                          ),
                          !checked
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Reset(),
                                          ));
                                    },
                                    color: Colors.red,
                                    child: Text(
                                      "Change Password",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          checked
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  child: FlatButton(
                                    onPressed: () {
                                      scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Working, please wait...."),
                                        backgroundColor: Colors.blue,
                                      ));
                                      changeName(_nameController.text);
                                    },
                                    color: Colors.blue,
                                    child: Text(
                                      "Change Profile",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void getProfile() async {
    var documentReference =
        Firestore.instance.collection('Users').document(widget.id);
    await Firestore.instance
        .collection("Users")
        .document(widget.id)
        .get()
        .then((value) {
      setState(() {
        profile_data.add(value.data);
        _nameController.text = profile_data[0]["name"].toString();
      });
    });
  }

  void changeName(String user_name) async {
    var documentReference =
        Firestore.instance.collection('Users').document(widget.id);
    await Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
        documentReference,
        {
          'name': user_name,
        },
      );
    }).then((value) {
      setState(() {
        profile_data.clear();
        getProfile();
        checked = false;
      });
    });
  }

  void changeImage(String image) async {
    var documentReference =
        Firestore.instance.collection('Users').document(widget.id);
    await Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
        documentReference,
        {
          'image': image,
        },
      );
    }).then((value) {
      setState(() {
        profile_data.clear();
        getProfile();
      });
    });
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
}
