import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupInformationScreen extends StatelessWidget {
  final String groupName;
  final Map<String, dynamic> groupData;
  const GroupInformationScreen({
    Key? key,
    required this.groupData,
    required this.groupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = groupData["date"].toDate() ?? DateTime.now();

    String dateTimeAgo = timeago.format(date);
    List<dynamic> members = groupData["members"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Group Details: $groupName"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text("Group created: $dateTimeAgo"),
            ),
            ListTile(
              leading: const Icon(Icons.title),
              title: Text("Name: $groupName"),
            ),
            ListTile(
              leading: const Icon(Icons.people_alt_outlined),
              title: Text("Total Member: ${members.length}"),
            ),
          ],
        ),
      ),
    );
  }
}
