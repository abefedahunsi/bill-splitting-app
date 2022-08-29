import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<DocumentSnapshot?> createGroup({
  required String name,
  required List<String> members,
  required List<Map<String, dynamic>> membersMeta,
}) async {
  try {
    User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      DocumentReference documentReference =
          await _firestore.collection("groups").add({
        'members': members,
        'membersMeta': membersMeta,
        'date': FieldValue.serverTimestamp(),
        'createdBy': uid,
        'name': name,
      });

      return await documentReference.get();
    } else {
      throw Exception("Unauthorized access!");
    }
  } catch (e) {
    log("$e");
    throw Exception("Error while creating group.\n$e");
  }
}
