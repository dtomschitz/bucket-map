part of shared.widgets;

class CountryListItem extends StatelessWidget {
  CountryListItem({this.country, this.onTap, this.trailing});

  final Country country;
  final Widget trailing;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CountryAvatar(country.code),
      title: Text(country.name),
      onTap: () => onTap?.call(),
      trailing: trailing != null ? trailing : null,
    );
  }
}
