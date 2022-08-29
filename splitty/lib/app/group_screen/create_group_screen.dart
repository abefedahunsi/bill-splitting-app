import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/app/group_screen/components/group_member_list_item.dart';
import 'package:splitty/app/group_screen/handlers/create_group.dart';
import 'package:splitty/app/group_screen/handlers/search_user.dart';
import 'package:splitty/common/alert_dialog.dart';
import 'package:splitty/providers/user_provider.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController searchMemberTextController =
      TextEditingController();

  final List<UserModel> groupMembers = [];

  bool _isBtnSaveTapped = false;

  @override
  void initState() {
    addMyProfileToGroupMembers();
    super.initState();
  }

  addMyProfileToGroupMembers() {
    UserModel me = ref.read(userProvider);

    groupMembers.add(me);
  }

  _searchAndAddMember(String searchValue) async {
    // search user and add

    String countryCode = "+91";

    if (searchValue.isNotEmpty) {
      UserModel? user =
          await searchUserByPhone(phone: "$countryCode$searchValue");
      if (user != null) {
        // user found
        searchMemberTextController.clear();

        int indexOfExistedUser =
            groupMembers.indexWhere((element) => element.uid == user.uid);

        if (indexOfExistedUser == -1) {
          setState(() {
            groupMembers.add(user);
          });
        }
      } else {
        // user not found
        showAlertDialog(
          context: context,
          title: "oops!",
          description: "No user found with this Phone Number.",
        );
      }
    } else {
      showAlertDialog(
        context: context,
        title: "oops!",
        description: "Please provide phone number to search user!",
      );
    }
  }

  _btnSaveTap() async {
    // create group if all details are correct

    try {
      String groupName = groupNameController.text;

      // check if group name is not empty, else return
      if (groupName.isEmpty) {
        showAlertDialog(
          context: context,
          title: "oh!",
          description: "Please provide group name...",
        );
        return;
      }

      // check if there is at least 2 group members
      if (groupMembers.length < 2) {
        showAlertDialog(
          context: context,
          title: "oops",
          description: "Please add atleast 1 more Member to create Group.",
        );
        return;
      }

      // prepare array only of UID of Members
      List<String> membersUID = [];
      List<Map<String, dynamic>> members = [];

      for (var member in groupMembers) {
        membersUID.add(member.uid);
        members.add({
          'name': member.name,
          'uid': member.uid,
          'phoneNumber': member.phoneNumber,
          'profileImage': member.profileImage,
        });
      }

      setState(() {
        _isBtnSaveTapped = true;
      });

      ScaffoldMessengerState scaffoldMessengerState =
          ScaffoldMessenger.of(context);
      NavigatorState navigatorState = Navigator.of(context);

      final res = await createGroup(
        name: groupName,
        membersMeta: membersUID,
        members: members,
      );

      if (res != null) {
        // showAlertDialog(
        //   context: context,
        //   title: "Done ✅",
        //   description: "Group created successfully.",
        // );

        scaffoldMessengerState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFFe5e5e5),
            content: const Text(
              "Group Created ✅",
              style: TextStyle(color: Colors.black, fontFamily: "Outfit"),
            ),
          ),
        );
        navigatorState.pop();
      }

      setState(() {
        _isBtnSaveTapped = false;
      });
    } catch (e) {
      log("$e");

      showAlertDialog(
        context: context,
        title: "oops!",
        description:
            "something went wrong while creating group, please try again later.",
      );

      setState(() {
        _isBtnSaveTapped = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text("Group Name"),
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
              controller: groupNameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              enableSuggestions: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Group name here...",
              ),
            ),
          ),
          const SizedBox(height: 26),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text("Group Members"),
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
              controller: searchMemberTextController,
              onSubmitted: (searchValue) {
                _searchAndAddMember(searchValue);
              },
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.search,
              enableSuggestions: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_outlined),
                border: InputBorder.none,
                hintText: "Write mobile to search...",
              ),
            ),
          ),
          const SizedBox(height: 26),
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
              itemBuilder: (context, index) => GroupMemberListItem(
                key: Key(groupMembers[index].uid),
                name: groupMembers[index].name,
                profileImage: groupMembers[index].profileImage,
                phoneNumber: groupMembers[index].phoneNumber,
                isMineProfile: groupMembers[index].isMineProfile,
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: groupMembers.length,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: _isBtnSaveTapped ? null : _btnSaveTap,
              child: const Text("save"),
            ),
          ),
        ],
      ),
    );
  }
}
