import 'package:flutter/material.dart';
import 'package:splitty/packages/shimmer/shimmer.dart';

class BillItemSkeleton extends StatelessWidget {
  const BillItemSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFF2F2F2),
      highlightColor: Colors.white,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE6E6E6),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: 20,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 180,
                      height: 14,
                      color: Colors.grey[200],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: 250,
              height: 14,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  size: 24,
                  color: Color(0xFF888888),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 80,
                  height: 14,
                  color: Colors.grey[200],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
