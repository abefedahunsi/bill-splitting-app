import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitty/providers/current_group_bills_provider.dart';

class GroupTotalExpenseScreen extends ConsumerWidget {
  const GroupTotalExpenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CurrentGroupBillModel> currentGroupBills =
        ref.watch(currentGroupBillsProvider);

    num totalExpense = 0;

    for (var bill in currentGroupBills) {
      num billAmount = bill.data["billAmount"] ?? 0;
      totalExpense += billAmount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Group's Total Expense"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.currency_rupee,
                  size: 48,
                ),
                Text(
                  "$totalExpense",
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text("${currentGroupBills.length} total bills"),
          ],
        ),
      ),
    );
  }
}
