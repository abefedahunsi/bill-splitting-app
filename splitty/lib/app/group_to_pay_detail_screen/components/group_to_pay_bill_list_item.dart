import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupToPayBillListItem extends StatelessWidget {
  final String billName;
  final num billAmount;
  final List<dynamic> members;
  final String billTypeImage;
  final bool needToPay;
  final bool billPaid;
  final GestureTapCallback onPayTap;
  final bool showPaymentBtn;

  const GroupToPayBillListItem({
    Key? key,
    required this.billName,
    required this.billAmount,
    required this.members,
    required this.billTypeImage,
    required this.needToPay,
    required this.billPaid,
    required this.onPayTap,
    required this.showPaymentBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalMembers = members.length;
    num splitAmount = billAmount / totalMembers;
    String splitAmountString = splitAmount.round().toString();

    return Container(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  width: 48,
                  height: 48,
                  image: CachedNetworkImageProvider(billTypeImage),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    billName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("Total Bill ₹$billAmount"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Split into $totalMembers (₹$splitAmountString)"),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 24,
                          color: Color(0xFF888888),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$totalMembers Members",
                          style: const TextStyle(
                            color: Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (needToPay) ...[
                if (showPaymentBtn) ...[
                  if (!billPaid) ...[
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                        ),
                        onPressed: onPayTap,
                        child: Text(
                          "Pay ₹$splitAmountString",
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      "Paid ₹$splitAmountString",
                      style: const TextStyle(color: Color(0xFF397C37)),
                    ),
                  ],
                ],
              ] else ...[
                const Text(
                  "No need to pay!",
                  style: TextStyle(
                    color: Color(0xFFF6CF43),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
