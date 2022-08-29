import 'package:flutter/material.dart';
import 'package:splitty/packages/shimmer/shimmer.dart';

class MyGroupsComponentSkeletonList extends StatelessWidget {
  const MyGroupsComponentSkeletonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (ctx, index) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFFF2F2F2),
            highlightColor: Colors.white,
            child: Container(
              height: 200,
              width: 180,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              margin: EdgeInsets.only(
                  left: index == 0 ? 30 : 10, right: index == 10 - 1 ? 30 : 10),
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
                        height: 22,
                        width: 120,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 22,
                        width: 120,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 14,
                        width: 80,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Container(
                    height: 14,
                    width: 40,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
