part of widgets;

class CountryListTile extends StatelessWidget {
  CountryListTile({
    this.country,
    this.trailing,
    this.onTap,
    bool showUnlockedDate,
  }) : this.showUnlockedDate = showUnlockedDate ?? false;

  final Country country;
  final Widget trailing;

  final Function() onTap;
  final bool showUnlockedDate;

  @override
  Widget build(BuildContext context) {
    final subtitle = showUnlockedDate && country.dateTime != null
        ? Text('Freigeschalten am ${Utils.formatDate(country.dateTime)}')
        : null;

    return ListTile(
      leading: CountryAvatar(country.code),
      title: Text(country.name),
      subtitle: subtitle,
      onTap: onTap?.call,
      trailing: trailing != null ? trailing : null,
    );
  }
}
