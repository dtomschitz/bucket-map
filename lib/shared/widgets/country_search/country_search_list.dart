part of shared.widgets;

class _CountrySearchList extends StatelessWidget {
  _CountrySearchList({this.query, this.filterOnlyUnlocked, this.onTap});

  final String query;
  final bool filterOnlyUnlocked;

  final Function(Country country) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesBloc, CountriesState>(
      builder: (context, state) {
        if (state is CountriesLoaded) {
          List<Country> countries = state.countries.where(
            (country) {
              return filterOnlyUnlocked
                  ? country.name.toLowerCase().contains(query.toLowerCase()) &&
                      country.unlocked
                  : country.name.toLowerCase().contains(query.toLowerCase());
            },
          ).toList();

          return CountryList(
            countries: countries,
            onTap: (country) {
              if (country != null) {
                onTap?.call(country);
              }
            },
          );
        }

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 32),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
