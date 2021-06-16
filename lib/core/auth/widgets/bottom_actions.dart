part of widgets.auth;

class BottomActions extends StatelessWidget {
  BottomActions({this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
