import 'dart:developer';

import 'package:url_launcher/url_launcher_string.dart';

Future<bool> launchUPIApp({
  required String upiAddress,
  required String name,
  required num amount,
  required String message,
}) async {
  try {
    String intent =
        "upi://pay?pa=$upiAddress&pn=$name&am=$amount&tn=$message&cu=INR";

    return await launchUrlString(
      intent,
      mode: LaunchMode.externalNonBrowserApplication,
    );
  } catch (e) {
    log("$e", name: "launch_upi_intent.dart");
    throw Exception(e);
  }
}
