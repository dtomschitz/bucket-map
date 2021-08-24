part of widgets;

class SharedAxisPageView extends StatelessWidget {
  SharedAxisPageView({
    @required this.views,
    @required this.currentView,
    this.transitionType = SharedAxisTransitionType.horizontal,
  });

  final List<Widget> views;
  final int currentView;

  final SharedAxisTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
        );
      },
      child: views[currentView],
    );
  }
}
