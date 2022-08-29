import 'package:flutter/material.dart';

class MyCreatedGroupDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          screenTitle,
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
        onPressed: () {},
      ),
    );
  }
}
