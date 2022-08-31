import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/app/group_screen/handlers/bill_handler.dart';
import 'package:splitty/config/images.dart';
import 'package:splitty/providers/current_group_bills_provider.dart';

import 'components/bill_list_item.dart';

class MyBillDetailScreen extends ConsumerWidget {
  final String groupName;
  final String groupId;
  final Map<String, dynamic> groupData;
  final String billId;

  const MyBillDetailScreen({
    Key? key,
    required this.groupName,
    required this.groupId,
    required this.groupData,
    required this.billId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CurrentGroupBillModel> currentGroupBills =
        ref.watch(currentGroupBillsProvider);

    int currentGroupBillIndex = currentGroupBills
        .indexWhere((currentGroupBill) => currentGroupBill.id == billId);

    Map<String, dynamic> billData =
        currentGroupBills[currentGroupBillIndex].data;

    List<dynamic> groupMembersMeta = groupData["membersMeta"] ?? [];

    String billName = billData["billName"] ?? "";
    num billAmount = billData["billAmount"] ?? 0;
    List<dynamic> billMembers = billData["billMembers"] ?? [];
    String billTypeImage =
        billData["billTypeImage"] ?? billItemImages.first.imageURL;

    List<dynamic> billPaidByMembers = billData["billPaidByMembers"] ?? [];

    String splitAmount = (billAmount / billMembers.length).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: Text("$groupName: $billName"),
      ),
      body: ListView(
        children: [
          BillListItem(
            billName: billName,
            billAmount: billAmount,
            members: billMembers,
            billTypeImage: billTypeImage,
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
                      if (billPaidByMembers.contains(uid)) ...[
                        Text(
                          "Paid ₹$splitAmount",
                          style: const TextStyle(
                            color: Color(0xFF397C37),
                          ),
                        ),
                        //TODO: add mark as not paid button
                      ] else ...[
                        Row(
                          children: [
                            const Text(
                              "Not Paid",
                              style: TextStyle(
                                color: Color(0xFFE54141),
                              ),
                            ),
                            PopupMenuButton(
                              color: Colors.grey[50],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              itemBuilder: (ctx) => [
                                PopupMenuItem(
                                  child: const Text("Mark as Paid"),
                                  onTap: () async {
                                    ScaffoldMessengerState
                                        scaffoldMessengerState =
                                        ScaffoldMessenger.of(context);

                                    // mark bill split for member as paid
                                    await billMarkAsPaidForUser(
                                      groupId: groupId,
                                      billId: billId,
                                      memberId: uid,
                                    );

                                    // update the state
                                    List<CurrentGroupBillModel>? bills =
                                        await getBills(groupId: groupId);

                                    if (bills != null) {
                                      ref
                                          .read(currentGroupBillsProvider.state)
                                          .state = bills;
                                    }

                                    // show message
                                    scaffoldMessengerState.showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        backgroundColor:
                                            const Color(0xFFe5e5e5),
                                        content: const Text(
                                          "Bill Split marked as Paid ✅",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Outfit",
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
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
