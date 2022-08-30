import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitty/app/group_screen/components/bill_split_select_member_item.dart';
import 'package:splitty/app/group_screen/handlers/bill_handler.dart';
import 'package:splitty/common/alert_dialog.dart';
import 'package:splitty/config/images.dart';

class CreateBillScreen extends StatefulWidget {
  final String docid;
  final Map<String, dynamic> groupData;
  const CreateBillScreen({
    Key? key,
    required this.docid,
    required this.groupData,
  }) : super(key: key);

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final TextEditingController billNameController = TextEditingController();
  final TextEditingController billAmountController = TextEditingController();

  String billType = billItemImages.first.id;
  String billTypeImage = billItemImages.first.imageURL;

  List<String> billSplitMembers = [];

  bool _isBtnSaveTapped = false;

  _showBillTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (dragScrollSheetContext, scrollController) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: ListView.separated(
                controller: scrollController,
                itemCount: billItemImages.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        billType = billItemImages[index].id;
                        billTypeImage = billItemImages[index].imageURL;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              width: 48,
                              height: 48,
                              image: CachedNetworkImageProvider(
                                  billItemImages[index].imageURL),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(billItemImages[index].name),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  _btnSaveTap() async {
    // save bill details

    // fetch details
    String billName = billNameController.text;
    num? billAmount = num.tryParse(billAmountController.text);

    if (billName.isEmpty) {
      showAlertDialog(
        context: context,
        title: "oops!",
        description: "Please provide Bill Name...",
      );
      return;
    }

    if (billAmount == null || billAmount <= 0) {
      showAlertDialog(
        context: context,
        title: "Bill Amount 🔴",
        description: "Please provide Bill amount...",
      );
      return;
    }

    if (billSplitMembers.length < 2) {
      showAlertDialog(
        context: context,
        title: "Select Members 🔴",
        description: "Please select 2 or more members to split the bill.",
      );
      return;
    }

    try {
      ScaffoldMessengerState scaffoldMessengerState =
          ScaffoldMessenger.of(context);
      NavigatorState navigatorState = Navigator.of(context);

      setState(() {
        _isBtnSaveTapped = true;
      });

      await createBill(
        groupId: widget.docid,
        billName: billName,
        billAmount: billAmount,
        billType: billType,
        billTypeImage: billTypeImage,
        billMembers: billSplitMembers,
      );

      // show message that bill is created
      scaffoldMessengerState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFFe5e5e5),
          content: const Text(
            "Bill Created ✅",
            style: TextStyle(color: Colors.black, fontFamily: "Outfit"),
          ),
        ),
      );

      // pop current screen
      navigatorState.pop();
    } catch (e) {
      showAlertDialog(
        context: context,
        title: "oops!",
        description:
            "Something went wrong while creating bill. try again later.\n$e",
      );
      log("$e");
      setState(() {
        _isBtnSaveTapped = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<dynamic> members = widget.groupData["members"] ?? [];
    List<dynamic> membersMeta = widget.groupData["membersMeta"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Bill Split"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text("Bill Name"),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: billNameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              enableSuggestions: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Bill title here...",
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text("Bill Amount"),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: billAmountController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                prefixText: "₹",
                border: InputBorder.none,
                hintText: "Enter Bill Amount here...",
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text("Bill Type"),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _showBillTypeBottomSheet();
            },
            child: Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      width: 48,
                      height: 48,
                      image: CachedNetworkImageProvider(billTypeImage),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("Tap to change bill type"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text("Select Members"),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                dynamic member = membersMeta[index];
                String uid = member["uid"] ?? "";
                String name = member["name"] ?? "";
                String phoneNumber = member["phoneNumber"] ?? "";
                String profileImage = member["profileImage"] ?? "";

                return GestureDetector(
                  onTap: () {
                    if (billSplitMembers.contains(uid)) {
                      setState(() {
                        billSplitMembers.remove(uid);
                      });
                    } else {
                      setState(() {
                        billSplitMembers.add(uid);
                      });
                    }
                  },
                  child: BillSplitSelectMemberListItem(
                    name: name,
                    profileImage: profileImage,
                    phoneNumber: phoneNumber,
                    isSelected: billSplitMembers.contains(uid),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: membersMeta.length,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: _isBtnSaveTapped ? null : _btnSaveTap,
              child: const Text("Create bill"),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
