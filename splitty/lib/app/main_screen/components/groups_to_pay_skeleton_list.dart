import 'package:flutter/material.dart';
import 'package:splitty/packages/shimmer/shimmer.dart';

class GroupsToPaySkeletonList extends StatelessWidget {
  const GroupsToPaySkeletonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (ctx, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFFF2F2F2),
          highlightColor: Colors.white,
          child: Container(
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
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
                    Container(
                      height: 20,
                      width: 220,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 160,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 14,
                  width: 120,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
