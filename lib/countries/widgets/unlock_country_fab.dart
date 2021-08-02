part of countries.widgets;

class UnlockCountryFab extends StatefulWidget {
  @override
  State createState() => _UnlockCountryFabState();
}

class _UnlockCountryFabState extends State<UnlockCountryFab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final circleFabBorder = const CircleBorder();

    return OpenContainer(
      openColor: theme.cardColor,
      closedShape: circleFabBorder,
      closedColor: theme.colorScheme.secondary,
      //transitionDuration: Duration(seconds: 5),
      openBuilder: (context, closedContainer) {
        return CreatePinScreen();
      },
      closedBuilder: (context, openContainer) {
        return FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            openContainer();
          },
        );
      },
    );
  }
}
