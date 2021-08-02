part of shared.widgets;

class CountrySearch extends SearchDelegate<Country> {
  CountrySearch({String label, bool filterOnlyUnlocked})
      : label = label ?? 'Nach Land suchen',
        filterOnlyUnlocked = filterOnlyUnlocked ?? false;

  final String label;
  final bool filterOnlyUnlocked;

  static Future<Country> show(BuildContext context) {
    return showSearch<Country>(
      context: context,
      delegate: CountrySearch(),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _CountrySearchList(
      query: query,
      filterOnlyUnlocked: filterOnlyUnlocked,
      onTap: (country) => close(context, country),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _CountrySearchList(
      query: query,
      filterOnlyUnlocked: filterOnlyUnlocked,
      onTap: (country) => close(context, country),
    );
  }

  @override
  String get searchFieldLabel => label;
}

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
