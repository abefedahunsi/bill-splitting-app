import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitty/config/colors.dart';

class GroupMemberListItem extends StatelessWidget {
  final String name, profileImage, phoneNumber;
  final bool isMineProfile;
  const GroupMemberListItem({
    Key? key,
    required this.name,
    required this.profileImage,
    required this.phoneNumber,
    this.isMineProfile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[200],
              backgroundImage: CachedNetworkImageProvider(profileImage),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
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
        if (isMineProfile) ...[
          const Text(
            "ME",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
        ],
      ],
    );
  }
}
