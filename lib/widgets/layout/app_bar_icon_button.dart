part of widgets;

class AppBarIconButton extends StatelessWidget {
  AppBarIconButton({this.icon, this.onPressed});

  final Icon icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Colors.black.withOpacity(.15),
        child: IconButton(
          constraints: BoxConstraints(maxHeight: 46),
          icon: icon,
          iconSize: 24.0,
          color: Colors.white,
          onPressed: onPressed?.call,
        ),
      ),
    );
  }
}
