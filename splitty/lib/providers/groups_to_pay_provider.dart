import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'my_groups_provider.dart';

final groupsToPayProvider = StateProvider<List<MyGroupModel>>((ref) => []);
