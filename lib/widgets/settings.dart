import 'package:flutter/material.dart';

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

class SettingsTile extends StatelessWidget {
  SettingsTile({
    this.title,
    this.subtitle,
    this.onTap,
    this.trailing = const Icon(Icons.chevron_right_outlined),
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? null,
      onTap: onTap,
    );
  }
}

class SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 16,
      endIndent: 16,
    );
  }
}
