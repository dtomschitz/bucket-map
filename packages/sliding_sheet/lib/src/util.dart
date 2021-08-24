import 'package:flutter/material.dart';

void postFrame(VoidCallback callback) {
  WidgetsBinding.instance?.addPostFrameCallback((_) => callback());
}

T swapSign<T extends num>(T value) {
  return value.isNegative ? value.abs() as T : value * -1 as T;
}

double toPrecision(double value, [int precision = 3]) {
  return double.parse(value.toStringAsFixed(precision));
}

class Invisible extends StatelessWidget {
  final bool invisible;
  final Widget? child;
  const Invisible({
    Key? key,
    this.invisible = false,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !invisible,
      maintainInteractivity: false,
      maintainSemantics: true,
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
      child: child!,
    );
  }
}
