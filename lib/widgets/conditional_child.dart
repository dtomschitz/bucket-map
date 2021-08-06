part of widgets;

class ConditionalChild extends StatelessWidget {
  ConditionalChild({this.condition, this.child});
  final Widget child;
  final bool condition;

  @override
  Widget build(BuildContext context) {
    return condition ? child : Container();
  }
}
