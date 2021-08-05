part of widgets;

class CountrySelect extends StatefulWidget {
  @override
  State createState() => _CountrySelectState();
}

class _CountrySelectState extends State<CountrySelect> {
  Country _country;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CountryAvatar(_country == null ? null : _country.code),
      title: Text(_country == null ? 'Wähle das Land' : _country.name),
      trailing: Icon(Icons.chevron_right_rounded),
      onTap: () async {
        final country = await CountrySearch.show(context);
        setState(() => _country = country);
      },
    );
  }
}
