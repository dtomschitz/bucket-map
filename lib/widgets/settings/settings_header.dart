part of widgets;

class SettingsHeader extends StatelessWidget {
  SettingsHeader(this.heading);

  final String heading;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        heading,
        style: textStyle.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
