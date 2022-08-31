import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/app/group_screen/handlers/bill_handler.dart';
import 'package:splitty/app/group_to_pay_detail_screen/components/group_to_pay_bill_list_item.dart';
import 'package:splitty/app/group_to_pay_detail_screen/handlers/get_my_uid.dart';
import 'package:splitty/config/images.dart';
import 'package:splitty/providers/current_group_bills_provider.dart';

import '../group_screen/components/bill_item_skeleton.dart';

class GroupToPayDetailScreen extends ConsumerStatefulWidget {
  final String screenTitle;
  final String docid;
  final Map<String, dynamic> groupData;

  const GroupToPayDetailScreen({
    Key? key,
    required this.screenTitle,
    required this.docid,
    required this.groupData,
  }) : super(key: key);

  @override
  ConsumerState<GroupToPayDetailScreen> createState() =>
      _GroupToPayDetailScreenState();
}

class _GroupToPayDetailScreenState
    extends ConsumerState<GroupToPayDetailScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    _getGroupBills();
    super.initState();
  }

  _getGroupBills() async {
    // get all bills from group

    try {
      List<CurrentGroupBillModel>? bills =
          await getBills(groupId: widget.docid);

      if (bills != null) {
        ref.read(currentGroupBillsProvider.state).state = bills;

        setState(() {
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      log("$e", name: "group_to_pay_detail_screen.dart");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CurrentGroupBillModel> currentGroupBills =
        ref.watch(currentGroupBillsProvider);
    String uid = getMyUID();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.screenTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        actions: [
          PopupMenuButton(
            color: Colors.grey[50],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (c) => [
              PopupMenuItem(
                  child: const Text("Group Details"),
                  onTap: () {
                    //TODO: show group details into separate screen
                  }),
              PopupMenuItem(
                  child: const Text("Total Expense"),
                  onTap: () {
                    //TODO: show total expense of group
                  }),
            ],
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: _isLoading
          ? ListView.builder(
              itemBuilder: (ctx, index) => const BillItemSkeleton(),
              itemCount: 10,
            )
          : currentGroupBills.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (ctx, index) {
                    CurrentGroupBillModel bill = currentGroupBills[index];
                    String id = bill.id;
                    Map<String, dynamic> data = bill.data;

                    String billName = data["billName"] ?? "";
                    num billAmount = data["billAmount"] ?? 0;
                    List<dynamic> members = data["billMembers"] ?? [];
                    List<dynamic> billPaidByMembers =
                        data["billPaidByMembers"] ?? [];
                    String billTypeImage =
                        data["billTypeImage"] ?? billItemImages.first.imageURL;

                    bool needToPay = members.contains(uid);
                    bool billPaid = billPaidByMembers.contains(uid);

                    return GestureDetector(
                      onTap: () {
                        //TODO: open bill detail

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => MyBillDetailScreen(
                        //       groupName: widget.screenTitle,
                        //       groupId: widget.docid,
                        //       groupData: widget.groupData,
                        //       billId: id,
                        //     ),
                        //   ),
                        // );
                      },
                      child: GroupToPayBillListItem(
                        billName: billName,
                        billAmount: billAmount,
                        members: members,
                        billTypeImage: billTypeImage,
                        needToPay: needToPay,
                        billPaid: billPaid,
                        onPayTap: () {
                          //TODO: show payment option and mark as paid
                        },
                      ),
                    );
                  },
                  itemCount: currentGroupBills.length,
                )
              : const Center(
                  child: Text(
                    "No bills found!, create one to see it here.",
                    textAlign: TextAlign.center,
                  ),
                ),
    );
  }
}
