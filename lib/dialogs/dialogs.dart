library dialogs;

import 'dart:async';

import 'package:bucket_map/shared/shared.dart';
import 'package:flutter/material.dart';

part 'cancel_modify_pin.dart';
part 'confirmation.dart';
part 'delete_pin.dart';
part 'discard_changes.dart';

Future<T> showAppDialog<T>(
  BuildContext context, {
  Widget dialog,
}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) => dialog,
  );
}
