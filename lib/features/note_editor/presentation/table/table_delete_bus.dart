import 'package:flutter/foundation.dart';

class TableDeleteBus {
  static final ValueNotifier<String?> armedId = ValueNotifier<String?>(null);
  static void arm(String id) => armedId.value = id;
  static void clearAll() => armedId.value = null;
}
