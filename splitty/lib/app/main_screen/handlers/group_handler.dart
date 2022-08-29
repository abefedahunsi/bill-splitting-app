import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

// get initial 10 groups
Future<List<QueryDocumentSnapshot>?> getMyGroups({int limit = 10}) async {
  User? user = _auth.currentUser;

  try {
    if (user != null) {
      String uid = user.uid;

      QuerySnapshot querySnapshot = await _firestore
          .collection("groups")
          .where("createdBy", isEqualTo: uid)
          .orderBy("date", descending: true)
          .limit(limit)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      } else {
        return [];
      }
    } else {
      throw Exception("Unauthorized access");
    }
  } catch (e) {
    log("$e");
    throw Exception("error while getting my groups!\n$e");
  }
}

// get more groups
