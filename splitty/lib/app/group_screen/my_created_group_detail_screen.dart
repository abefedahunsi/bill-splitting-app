import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/app/group_screen/components/bill_item_skeleton.dart';
import 'package:splitty/app/group_screen/components/bill_list_item.dart';
import 'package:splitty/app/group_screen/create_bill_screen.dart';
import 'package:splitty/app/group_screen/handlers/bill_handler.dart';
import 'package:splitty/config/images.dart';
import 'package:splitty/providers/current_group_bills_provider.dart';

class MyCreatedGroupDetailScreen extends ConsumerStatefulWidget {
  final String screenTitle;
  final String docid;
  final Map<String, dynamic> groupData;
  const MyCreatedGroupDetailScreen({
    Key? key,
    required this.screenTitle,
    required this.docid,
    required this.groupData,
  }) : super(key: key);

  @override
  ConsumerState<MyCreatedGroupDetailScreen> createState() =>
      _MyCreatedGroupDetailScreenState();
}

class _MyCreatedGroupDetailScreenState
    extends ConsumerState<MyCreatedGroupDetailScreen> {
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
      log("$e", name: "my_created_group_detail_screen.dart");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CurrentGroupBillModel> currentGroupBills =
        ref.watch(currentGroupBillsProvider);

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
              PopupMenuItem(child: const Text("Group Details"), onTap: () {}),
              PopupMenuItem(child: const Text("Total Expense"), onTap: () {}),
            ],
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: const Text("create bill"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateBillScreen(
                docid: widget.docid,
                groupData: widget.groupData,
              ),
            ),
          );
        },
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
                    String billTypeImage =
                        data["billTypeImage"] ?? billItemImages.first.imageURL;

                    return GestureDetector(
                      onTap: () {
                        //TODO: open bill detail screen
                        log(id);
                      },
                      child: BillListItem(
                        billName: billName,
                        billAmount: billAmount,
                        members: members,
                        billTypeImage: billTypeImage,
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
