part of widgets;

class SettingsSection extends StatelessWidget {
  SettingsSection({this.header, this.tiles});

  final SettingsHeader header;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [this.header, ...this.tiles, SettingsDivider()],
      ),
    );
  }
}
