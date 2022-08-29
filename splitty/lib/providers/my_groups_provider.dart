import 'package:flutter_riverpod/flutter_riverpod.dart';

final myGroupsProvider = StateProvider<List<MyGroupModel>>((ref) => []);

class MyGroupModel {
  final String id;
  final Map<String, dynamic> data;

  MyGroupModel({
    required this.id,
    required this.data,
  });
}
