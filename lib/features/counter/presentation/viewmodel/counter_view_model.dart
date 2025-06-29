import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterViewModel extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final counterProvider =
    NotifierProvider<CounterViewModel, int>(CounterViewModel.new);
