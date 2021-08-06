part of widgets;

class CountrySelect extends StatefulWidget {
  CountrySelect({this.country, this.onChange});

  final Country country;
  final Function(Country country) onChange;

  @override
  State createState() => _CountrySelectState(country);
}

class _CountrySelectState extends State<CountrySelect> {
  _CountrySelectState(this._country);
  Country _country;

  @override
  void didUpdateWidget(CountrySelect oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.country != _country || _country == null) {
      setState(() => _country = widget.country);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CountryAvatar(_country == null ? null : _country.code),
      title: Text(_country == null ? 'Wähle das Land' : _country.name),
      trailing: Icon(Icons.chevron_right_rounded),
      onTap: () async {
        final country = await CountrySearch.show(context);
        setState(() => _country = country);

        widget.onChange?.call(country);
      },
    );
  }
}
