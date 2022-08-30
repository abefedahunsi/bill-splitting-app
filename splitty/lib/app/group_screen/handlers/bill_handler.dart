import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitty/providers/current_group_bills_provider.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<DocumentSnapshot?> createBill({
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

    return await ref.get();
  } catch (e) {
    log("$e", name: "bill_handler.dart");
    throw Exception("Error while creating bill.\n$e");
  }
}

// get group's bills
Future<List<CurrentGroupBillModel>?> getBills({
  required String groupId,
}) async {
  try {
    QuerySnapshot querySnapshot = await _firestore
        .collection("groups")
        .doc(groupId)
        .collection("bills")
        .orderBy("date", descending: true)
        .limit(20)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      List<CurrentGroupBillModel> docs = [];
      for (var qdoc in querySnapshot.docs) {
        String id = qdoc.id;
        Map<String, dynamic>? data = qdoc.data() as Map<String, dynamic>?;

        if (data != null) {
          docs.add(CurrentGroupBillModel(id: id, data: data));
        }
      }
      return docs;
    } else {
      return [];
    }
  } catch (e) {
    log("$e", name: "bill_handler.dart");
    throw Exception("Error while getting bill.\n$e");
  }
}
