import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> addUserInfo({
  required String name,
  required String upiId,
  required String profileImage,
}) async {
  try {
    User? user = auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      String phoneNumber = user.phoneNumber ?? "";

      await firestore.collection("users").doc(uid).set({
        "createdAt": FieldValue.serverTimestamp(),
        "name": name,
        "profileImage": profileImage,
        "phoneNumber": phoneNumber,
        "upiId": upiId,
      }, SetOptions(merge: true));
    } else {
      throw Exception("unauthorized call to save user info.");
    }
  } catch (e) {
    debugPrint(e.toString());
    throw Exception("Error adding User information to DB.");
  }
}

Future<Map<String, dynamic>?> getUserInfo() async {
  User? user = auth.currentUser;

  if (user != null) {
    String userId = user.uid;
    DocumentSnapshot docSnap =
        await firestore.collection("users").doc(userId).get();
    if (docSnap.exists) {
      Map<String, dynamic>? data = docSnap.data() as Map<String, dynamic>?;
      return data;
    }
  }
  return null;
}

Future<void> logOut() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await auth.signOut();
}
