part of profile.widgets;

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
