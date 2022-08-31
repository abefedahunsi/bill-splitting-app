import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/app/group_screen/handlers/bill_handler.dart';
import 'package:splitty/app/group_to_pay_detail_screen/components/group_to_pay_bill_list_item.dart';
import 'package:splitty/app/group_to_pay_detail_screen/handlers/get_my_uid.dart';
import 'package:splitty/app/group_to_pay_detail_screen/handlers/pay_bill_handler.dart';
import 'package:splitty/common/alert_dialog.dart';
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

  _showPaymentOption({
    required String uid,
    required String billId,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          maxChildSize: 0.3,
          expand: false,
          builder: (dcontext, scrollController) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: ListView(
                controller: scrollController,
                children: [
                  ListTile(
                    leading: const Icon(Icons.payments_outlined),
                    title: const Text("Pay Cash"),
                    onTap: () {
                      showConfirmAlertDialog(
                        context: dcontext,
                        title: "Confirmation!",
                        description:
                            "You've selected Pay Using Cash option, if you are sure, then tap on confirm.",
                        onConfirm: () {
                          _payBillUsingCash(memberId: uid, billId: billId);

                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.currency_rupee),
                    title: const Text("Pay Using UPI"),
                    onTap: () {
                      //TODO: add upi payment
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  _payBillUsingCash({
    required String memberId,
    required String billId,
  }) async {
    ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);

    await payBillUsingCash(
      groupId: widget.docid,
      billId: billId,
      memberId: memberId,
    );

    // fetch updated details &
    // update state provider

    // update the state
    List<CurrentGroupBillModel>? bills = await getBills(groupId: widget.docid);

    if (bills != null) {
      ref.read(currentGroupBillsProvider.state).state = bills;
    }

    // show message
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFFe5e5e5),
        content: const Text(
          "Bill Split marked as Paid ✅",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Outfit",
          ),
        ),
      ),
    );
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

                          _showPaymentOption(uid: uid, billId: id);
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