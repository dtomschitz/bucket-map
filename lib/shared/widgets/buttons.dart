part of shared.widgets;

class WarningButton extends StatelessWidget {
  const WarningButton({this.child, this.onPressed, Key key}) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: Themes.warningButtonStyle,
    );
  }
}

class AccentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AccentButton({this.child, this.onPressed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RaisedButton(
      onPressed: onPressed,
      child: child,
      textColor: theme.accentTextTheme.button.color,
      highlightColor: theme.accentColor,
      color: theme.accentColor,
    );
  }
}
