import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/config/images.dart';
import 'package:splitty/providers/current_group_bills_provider.dart';

import 'components/group_to_pay_bill_list_item.dart';
import 'handlers/get_my_uid.dart';

class BillDetailScreen extends ConsumerWidget {
  final String groupName;
  final String groupId;
  final Map<String, dynamic> groupData;
  final String billId;
  const BillDetailScreen({
    Key? key,
    required this.groupName,
    required this.groupId,
    required this.groupData,
    required this.billId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String myUid = getMyUID();

    List<CurrentGroupBillModel> currentGroupBills =
        ref.watch(currentGroupBillsProvider);

    int currentGroupBillIndex = currentGroupBills
        .indexWhere((currentGroupBill) => currentGroupBill.id == billId);

    List<dynamic> groupMembersMeta = groupData["membersMeta"] ?? [];

    CurrentGroupBillModel bill = currentGroupBills[currentGroupBillIndex];
    Map<String, dynamic> data = bill.data;

    String billName = data["billName"] ?? "";
    num billAmount = data["billAmount"] ?? 0;
    List<dynamic> billMembers = data["billMembers"] ?? [];
    List<dynamic> billPaidByMembers = data["billPaidByMembers"] ?? [];
    String billTypeImage =
        data["billTypeImage"] ?? billItemImages.first.imageURL;

    bool needToPay = billMembers.contains(myUid);
    bool billPaid = billPaidByMembers.contains(myUid);

    num splitAmount = (billAmount / billMembers.length);

    return Scaffold(
      appBar: AppBar(
        title: Text("$groupName: $billName"),
      ),
      body: ListView(
        children: [
          GroupToPayBillListItem(
            billName: billName,
            billAmount: billAmount,
            members: billMembers,
            billTypeImage: billTypeImage,
            needToPay: needToPay,
            billPaid: billPaid,
            showPaymentBtn: false,
            onPayTap: () {},
          ),
          const SizedBox(height: 40),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: billMembers.length,
              itemBuilder: (ctx, index) {
                int memberMetaIndex = groupMembersMeta.indexWhere(
                    (groupMember) => groupMember["uid"] == billMembers[index]);

                dynamic billMemberMeta = groupMembersMeta[memberMetaIndex];
                String memberName = billMemberMeta["name"] ?? "";
                String profileImage = billMemberMeta["profileImage"] ?? "";
                String phoneNumber = billMemberMeta["phoneNumber"] ?? "";
                String uid = billMemberMeta["uid"] ?? "";

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                CachedNetworkImageProvider(profileImage),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                memberName,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                phoneNumber,
                                style: const TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (billMembers.contains(uid)) ...[
                        if (billPaidByMembers.contains(uid)) ...[
                          Text(
                            "Paid ₹${splitAmount.round().toString()}",
                            style: const TextStyle(
                              color: Color(0xFF397C37),
                            ),
                          ),
                        ] else ...[
                          const Text(
                            "Not Paid",
                            style: TextStyle(
                              color: Color(0xFFE54141),
                            ),
                          ),
                        ],
                      ] else ...[
                        const Text(
                          "No need to pay.",
                          style: TextStyle(
                            color: Color(0xFFF6CF43),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
