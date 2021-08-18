library core.snack_bars;

import 'package:flutter/material.dart';

part 'copy_coordinates_to_clipboard.dart';
part 'email_not_in_use.dart';
part 'login_failed.dart';

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
