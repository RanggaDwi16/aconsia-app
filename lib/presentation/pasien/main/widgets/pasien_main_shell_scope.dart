import 'package:flutter/widgets.dart';

class PasienMainShellScope extends InheritedWidget {
  final VoidCallback openDrawer;

  const PasienMainShellScope({
    super.key,
    required this.openDrawer,
    required super.child,
  });

  static PasienMainShellScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PasienMainShellScope>();
  }

  @override
  bool updateShouldNotify(covariant PasienMainShellScope oldWidget) {
    return openDrawer != oldWidget.openDrawer;
  }
}
