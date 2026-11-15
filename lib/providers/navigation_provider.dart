import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;

  void goToBeranda() => state = 0;
  void goToExplore() => state = 1;
  void goToRencanaku() => state = 2;
  void goToBookmark() => state = 3;
}

final navigationProvider = NotifierProvider<NavigationNotifier, int>(
  NavigationNotifier.new,
);
