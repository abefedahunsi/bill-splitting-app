import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

createBill({
  required String groupId,
  required String billName,
  required num billAmount,
  required String billType,
  required String billTypeImage,
  required List<String> billMembers,
}) async {
  try {
    DocumentReference ref = await _firestore
        .collection("groups")
        .doc(groupId)
        .collection("bills")
        .add({
      "date": FieldValue.serverTimestamp(),
      "billName": billName,
      "billAmount": billAmount,
      "billType": billType,
      "billTypeImage": billTypeImage,
      "billMembers": billMembers,
      "billPaidByMembers": [],
    });

    await ref.get();
  } catch (e) {
    log("$e", name: "bill_handler.dart");
    throw Exception("Error while creating bill.\n$e");
  }
}
