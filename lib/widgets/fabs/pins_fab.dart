part of widgets;

class PinsFab extends StatefulWidget {
  @override
  State createState() => _PinsFabState();
}

class _PinsFabState extends State<PinsFab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final circleFabBorder = const CircleBorder();

    return OpenContainer(
      openColor: theme.cardColor,
      closedShape: circleFabBorder,
      closedColor: theme.colorScheme.secondary,
      openBuilder: (context, closedContainer) {
        return SavedLocationsScreen();
      },
      closedBuilder: (context, openContainer) {
        return FloatingActionButton(
          child: Icon(Icons.explore_outlined),
          onPressed: () {
            openContainer();
          },
        );
      },
    );
  }
}
