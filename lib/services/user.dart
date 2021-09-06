import 'package:firebase_auth/firebase_auth.dart';

class User{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /*getUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }*/
}