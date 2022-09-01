import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/app/group_to_pay_detail_screen/group_to_pay_detail_screen.dart';
import 'package:splitty/config/colors.dart';
import 'package:splitty/providers/groups_to_pay_provider.dart';
import 'package:splitty/providers/my_groups_provider.dart';

import 'components/groups_to_pay_skeleton_list.dart';
import 'handlers/group_handler.dart';

class ViewAllGroupsScreen extends ConsumerStatefulWidget {
  const ViewAllGroupsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewAllGroupsScreen> createState() =>
      _ViewAllGroupsScreenState();
}

class _ViewAllGroupsScreenState extends ConsumerState<ViewAllGroupsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    _getGroupsToPay();

    super.initState();
  }

  _getGroupsToPay() async {
    try {
      List<MyGroupModel>? res = await getGroupsToPay(limit: 50);
      if (res != null) {
        ref.read(groupsToPayProvider.state).state = res;

        setState(() {
          _isLoading = false;
        });
        return;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      log("$e", name: "view_all_groups_screen.dart");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MyGroupModel> groupsToPay = ref.watch(groupsToPayProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups to Pay"),
      ),
      body: !_isLoading
          ? groupsToPay.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: groupsToPay.length,
                  itemBuilder: (ctx, index) {
                    MyGroupModel group = groupsToPay[index];
                    Map<String, dynamic> groupData = group.data;

                    String groupName = groupData["name"] ?? "";
                    List<dynamic> members = groupData["members"] ?? [];
                    List<dynamic> membersMeta = groupData["membersMeta"] ?? [];

                    int totalMembers = members.length;

                    String createdByUID = groupData["createdBy"] ?? "";
                    int createdByMemberMetaIndex = membersMeta.indexWhere(
                        (element) => element["uid"] == createdByUID);

                    dynamic createdByMemberMeta =
                        membersMeta[createdByMemberMetaIndex];
                    String createdByMemberName =
                        createdByMemberMeta["name"] ?? "";

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupToPayDetailScreen(
                              screenTitle: groupName,
                              docid: group.id,
                              groupData: groupData,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE6E6E6),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  groupName,
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    text: "Created by",
                                    children: [
                                      TextSpan(
                                        text: " $createdByMemberName",
                                        style: TextStyle(
                                          color: primarySwatch.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(
                                  Icons.people_outline,
                                  color: Color(0xFF888888),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "$totalMembers Members",
                                  style: const TextStyle(
                                    color: Color(0xFF888888),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Text(
                  "No Groups found! When someone adds you into the group, you will see them here.",
                  textAlign: TextAlign.center,
                )
          : const GroupsToPaySkeletonList(),
    );
  }
}
