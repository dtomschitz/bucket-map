part of widgets;

class PermissionBuilder extends StatelessWidget {
  const PermissionBuilder({
    Key key,
    this.permission,
    this.builder,
    this.autoRequestPermission = true,
  }) : super(key: key);

  final Permission permission;

  final dynamic Function(
    BuildContext context,
    AsyncSnapshot<PermissionStatus> snapshot,
  ) builder;

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

        return this.builder(context, snapshot) ?? Container();
      },
    );
  }
}
