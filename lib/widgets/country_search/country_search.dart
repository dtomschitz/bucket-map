part of widgets;

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

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        brightness: colorScheme.brightness,
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
        //iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        textTheme: theme.textTheme,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }
}
