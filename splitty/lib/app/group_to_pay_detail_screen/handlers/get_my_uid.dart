import 'package:firebase_auth/firebase_auth.dart';

String getMyUID() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  }
  return "";
}
