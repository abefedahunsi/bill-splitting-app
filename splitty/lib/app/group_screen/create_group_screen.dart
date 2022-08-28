import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/app/group_screen/components/group_member_list_item.dart';
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

  @override
  void initState() {
    addMyProfileToGroupMembers();
    super.initState();
  }

  addMyProfileToGroupMembers() {
    UserModel me = ref.read(userProvider);

    groupMembers.add(
      me,
    );
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
              onPressed: () {},
              child: const Text("save"),
            ),
          ),
        ],
      ),
    );
  }
}
