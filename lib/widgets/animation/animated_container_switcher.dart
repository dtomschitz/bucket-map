part of widgets;

class AnimatedContainerSwitcher extends StatelessWidget {
  const AnimatedContainerSwitcher({
    this.duration = const Duration(milliseconds: 250),
    @required this.child,
  });

  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: child,
    );
  }
}
