import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

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

payBillUsingUPI() async {}
