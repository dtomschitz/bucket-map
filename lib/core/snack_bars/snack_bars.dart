library core.snack_bars;

import 'package:flutter/material.dart';

part 'copy_to_clipboard.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(
  BuildContext context,
  SnackBar snackBar,
) {
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
