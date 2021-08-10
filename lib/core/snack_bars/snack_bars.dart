library core.snack_bars;

import 'package:flutter/material.dart';

part 'copy_to_clipboard.dart';

abstract class DefaultSnackBar {
  SnackBar build(BuildContext context);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
    showSnackbar<T extends DefaultSnackBar>(
  BuildContext context,
  T Function() creator,
) {
  final snackBar = creator().build(context);
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
