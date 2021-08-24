part of widgets;

class CenteredIcon extends StatelessWidget {
  CenteredIcon({this.icon});
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).iconTheme.color,
      child: icon,
    );
  }
}
