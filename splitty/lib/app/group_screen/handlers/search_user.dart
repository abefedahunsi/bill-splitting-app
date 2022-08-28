import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitty/providers/user_provider.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<UserModel?> searchUserByPhone({required String phone}) async {
  try {
    final querySnap = await _firestore
        .collection("users")
        .where("phoneNumber", isEqualTo: phone)
        .limit(1)
        .get();

    if (querySnap.docs.isNotEmpty) {
      QueryDocumentSnapshot docSnap = querySnap.docs.first;
      if (docSnap.exists) {
        Map<String, dynamic>? data = docSnap.data() as Map<String, dynamic>?;
        if (data != null) {
          String name = data["name"] ?? "";
          String phoneNumber = data["phoneNumber"] ?? "";
          String profileImage = data["profileImage"] ?? "";

          return UserModel(
            name: name,
            phoneNumber: phoneNumber,
            profileImage: profileImage,
            uid: docSnap.id,
          );
        }
      }
    }
    return null;
  } catch (e) {
    log("$e");
    throw Exception("Something went wrong! $e");
  }
}
