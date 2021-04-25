part of widgets.settings;

class SettingsSection extends StatelessWidget {
  SettingsSection({this.header, this.tiles});

  final SettingsHeader header;
  final List<SettingsTile> tiles;

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
