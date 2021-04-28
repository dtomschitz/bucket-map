import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Permission].
class PermissionBuilder extends StatelessWidget {
  const PermissionBuilder(
      {Key key,
      this.permission,
      this.builder,
      this.autoRequestPermission = true})
      : super(key: key);

  /// The [Permission] of which the current status is connect to the inherited 
  /// [FutureBuilder] of this widget.
  final Permission permission;

  /// The build strategy currently used by this builder.
  final AsyncWidgetBuilder<PermissionStatus> builder;

  /// If true the [Permission] will get automatically requested. In case the 
  /// [Permission] is denied permanently the app settings page will be opened.
  ///
  /// Defaults to true.
  final bool autoRequestPermission;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: this.permission.status,
      builder: (context, snapshot) {
        if (this.autoRequestPermission) {
          PermissionStatus status = snapshot.data;
          if (status == PermissionStatus.permanentlyDenied) {
            openAppSettings();
          } else if (status == PermissionStatus.denied) {
            this.permission.request();
          }
        }

        return this.builder(context, snapshot);
      },
    );
  }
}
