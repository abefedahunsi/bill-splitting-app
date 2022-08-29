import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/app/main_screen/components/my_groups_component_list_skeleton.dart';
import 'package:splitty/app/main_screen/handlers/group_handler.dart';
import 'package:splitty/config/colors.dart';

class MyGroupsComponent extends ConsumerStatefulWidget {
  const MyGroupsComponent({Key? key}) : super(key: key);

  @override
  ConsumerState<MyGroupsComponent> createState() => _MyGroupsComponentState();
}

class _MyGroupsComponentState extends ConsumerState<MyGroupsComponent> {
  bool _isLoading = true;
  List<QueryDocumentSnapshot> myGroups = [];

  @override
  void initState() {
    _getMyGroups();
    super.initState();
  }

  _getMyGroups() async {
    try {
      List<QueryDocumentSnapshot>? res = await getMyGroups();
      if (res != null) {
        setState(() {
          myGroups.addAll(res);
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      log("$e");

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "My Groups",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("View All"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (!_isLoading) ...[
          if (myGroups.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: myGroups.length,
                itemBuilder: (ctx, index) {
                  QueryDocumentSnapshot group = myGroups[index];
                  Map<String, dynamic>? groupData =
                      group.data() as Map<String, dynamic>?;

                  if (groupData != null) {
                    String groupName = groupData["name"] ?? "";
                    String createdBy = "ME";
                    dynamic members = groupData["members"] ?? [];
                    int totalMembers = members.length ?? 0;

                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 200,
                        width: 180,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 18),
                        margin: EdgeInsets.only(
                            left: index == 0 ? 30 : 10,
                            right: index == myGroups.length - 1 ? 30 : 10),
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
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Created by $createdBy",
                                  style: TextStyle(
                                    color: primarySwatch.shade400,
                                  ),
                                ),
                              ],
                            ),
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
                  }
                  return Container();
                },
              ),
            ),
          ] else ...[
            // show empty groups message
            const Text("No Groups found! Create a group to see it here...")
          ],
        ] else ...[
          // skeleton
          const MyGroupsComponentSkeletonList(),
        ],
      ],
    );
  }
}
