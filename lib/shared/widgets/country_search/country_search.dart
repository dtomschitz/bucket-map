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
