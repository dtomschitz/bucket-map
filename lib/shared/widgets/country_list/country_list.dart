part of shared.widgets;

class CountryList extends StatelessWidget {
  const CountryList({
    Key key,
    this.controller,
    this.physics,
    this.padding,
    this.shrinkWrap,
    this.countries,
    this.disabled,
    this.buildTrailing,
    this.onTap,
  }) : super(key: key);

  final ScrollController controller;
  final ScrollPhysics physics;
  final EdgeInsets padding;
  final bool shrinkWrap;

  final List<Country> countries;

  final void Function(Country country) onTap;
  final bool Function(Country country) disabled;

  final Widget Function(Country country) buildTrailing;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: GlobalKeys.countriesSheetList,
      controller: controller,
      padding: padding ?? EdgeInsets.only(top: 8, bottom: 8),
      shrinkWrap: shrinkWrap ?? true,
      itemCount: countries.length,
      physics: physics,
      itemBuilder: (BuildContext context, int index) {
        final country = countries[index];

        return ListTile(
          leading: CountryAvatar(country.code),
          title: Text(country.name),
          onTap: disabled != null && disabled.call(country)
              ? null
              : () => onTap(country),
          trailing: buildTrailing != null ? buildTrailing(country) : null,
        );
      },
    );
  }
}
