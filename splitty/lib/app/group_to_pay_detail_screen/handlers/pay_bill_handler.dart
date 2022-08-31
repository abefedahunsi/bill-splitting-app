import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitty/providers/user_provider.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> payBillUsingCash({
  required String groupId,
  required String billId,
  required String memberId,
}) async {
  try {
    await _firestore
        .collection("groups")
        .doc(groupId)
        .collection("bills")
        .doc(billId)
        .update({
      "billPaidByMembers": FieldValue.arrayUnion([memberId]),
    });
  } catch (e) {
    log("$e", name: "pay_bill_handler.dart");
    throw Exception("Error while marking bill split paid.\n$e");
  }
}

payBillUsingUPI({
  required String groupId,
  required String billId,
  required String memberId,
}) async {
  try {
    await _firestore
        .collection("groups")
        .doc(groupId)
        .collection("bills")
        .doc(billId)
        .update({
      "billPaidByMembers": FieldValue.arrayUnion([memberId]),
    });
  } catch (e) {
    log("$e", name: "pay_bill_handler.dart");
    throw Exception("Error while marking bill split paid.\n$e");
  }
}

Future<UserModel?> getUPIOfUser({required String uid}) async {
  try {
    DocumentSnapshot userDoc =
        await _firestore.collection("users").doc(uid).get();

    if (userDoc.exists) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      if (data != null) {
        String upiID = data["upiId"] ?? "";
        String name = data["name"] ?? "";
        String profileImage = data["profileImage"] ?? "";
        String phoneNumber = data["phoneNumber"] ?? "";

        return UserModel(
          name: name,
          phoneNumber: phoneNumber,
          profileImage: profileImage,
          uid: uid,
          upiId: upiID,
        );
      }
    }
    return null;
  } catch (e) {
    log("$e");
    throw Exception(e);
  }
}
