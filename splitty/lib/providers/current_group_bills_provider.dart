import 'package:flutter_riverpod/flutter_riverpod.dart';

// this provider gets detail when particular group is opened
final currentGroupBillsProvider =
    StateProvider<List<CurrentGroupBillModel>>((ref) => []);

class CurrentGroupBillModel {
  final String id;
  final Map<String, dynamic> data;

  CurrentGroupBillModel({
    required this.id,
    required this.data,
  });
}
