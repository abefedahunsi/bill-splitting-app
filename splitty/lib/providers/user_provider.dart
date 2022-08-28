import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserModel {
  final String name;
  final String phoneNumber;
  final String profileImage;
  final String upiId;
  final bool isMineProfile;
  final String uid;

  const UserModel({
    required this.name,
    required this.phoneNumber,
    required this.profileImage,
    required this.uid,
    this.upiId = '',
    this.isMineProfile = false,
  });
}

final StateProvider<UserModel> userProvider = StateProvider<UserModel>(
  (ref) => const UserModel(
    name: "",
    phoneNumber: "",
    profileImage: "",
    upiId: "",
    uid: "",
  ),
);
