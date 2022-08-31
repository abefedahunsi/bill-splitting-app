import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/app/group_screen/create_group_screen.dart';
import 'package:splitty/app/login/profile_setup_screen.dart';
import 'package:splitty/app/main_screen/components/my_groups_component.dart';
import 'package:splitty/config/images.dart';
import 'package:splitty/providers/user_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  _btnCreateGroupTap() {
    final userInfo = ref.read(userProvider);

    log("${userInfo.name} ${userInfo.phoneNumber} ${userInfo.upiId} ");

    // if user details are not available, ask user to fill up profile details.
    if (userInfo.name != "" &&
        userInfo.phoneNumber != "" &&
        userInfo.profileImage != "") {
      //
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateGroupScreen(),
        ),
      );
    } else {
      _showProfileIncompleteSnackBar();
    }
  }

  _showProfileIncompleteSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFFe5e5e5),
        content: const Text(
          "Please Complete your Profile information",
          style: TextStyle(color: Colors.black, fontFamily: "Outfit"),
        ),
        action: SnackBarAction(
          label: "Update",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileSetupScreen(),
              ),
            );
          },
        ),
        duration: const Duration(seconds: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));

    final userInfo = ref.watch(userProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ListView(
        children: [
          // appbar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSetupScreen(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: CachedNetworkImageProvider(
                      userInfo.profileImage != ""
                          ? userInfo.profileImage
                          : memojis.first.imageURL,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _btnCreateGroupTap();
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_rounded),
                  ),
                )
              ],
            ),
          ),
          // appbar

          // my groups section
          const MyGroupsComponent(),
          // my groups section

          // groups to pay
          //TODO: fetch groups that user needs to pay

          // groups to pay
        ],
      ),
    );
  }
}
