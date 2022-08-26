import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:splitty/app/main_screen/main_screen.dart';
import 'package:splitty/config/colors.dart';

import 'otp_send_and_verify_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _phoneNumber = '';

  @override
  void initState() {
    _isUserLoggedIn();
    super.initState();
  }

  void _isUserLoggedIn() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // remove native splash
      FlutterNativeSplash.remove();

      // send user to main screen if logged in
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Stack(
              children: [
                Container(
                  color: primaryColor,
                  height: 268,
                  width: size.width,
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Image(
                        image: const AssetImage(
                            "assets/login_screen_app_illustration.png"),
                        width: size.width,
                      ),
                    ),
                    const Center(
                      child: Image(
                        image: AssetImage("assets/splitty_text_logo.png"),
                        height: 50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "\"Pretty Bill Splitting App\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 30,
                      ),
                      child: const Text("Enter Mobile"),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IntlPhoneField(
                        initialCountryCode: 'IN',
                        decoration: const InputDecoration(
                          hintText: "Enter your phone number",
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        disableLengthCheck: true,
                        textInputAction: TextInputAction.done,
                        onChanged: (phone) {
                          setState(() {
                            _phoneNumber = phone.completeNumber;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_phoneNumber.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OtpSendAndVerifyScreen(
                                    phoneNumber: _phoneNumber),
                              ),
                            );
                          }
                        },
                        child: const Text("login with OTP"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}