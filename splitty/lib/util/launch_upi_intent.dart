import 'dart:developer';

Future<void> launchUPIApp({
  required String upiAddress,
  required String name,
  required num amount,
  required String message,
}) async {
  String intent =
      "upi://pay?pa=$upiAddress&pn=$name&am=$amount&tn=$message&cu=INR";
  log(intent);
}
