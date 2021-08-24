part of widgets;

class CountrySearch extends SearchDelegate<Country> {
  CountrySearch({String label, bool filterOnlyUnlocked})
      : label = label ?? 'Nach Land suchen',
        filterOnlyUnlocked = filterOnlyUnlocked ?? false;

  final String label;
  final bool filterOnlyUnlocked;

  static Future<Country> show(
    BuildContext context, {
    String label,
    bool filterOnlyUnlocked,
  }) {
    return showSearch<Country>(
      context: context,
      delegate: CountrySearch(
        label: label,
        filterOnlyUnlocked: filterOnlyUnlocked,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final color = Theme.of(context).iconTheme.color;

    return IconButton(
      icon: Icon(
        Icons.close,
        color: color,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return CountrySearchList(
      query: query,
      filterOnlyUnlocked: filterOnlyUnlocked,
      onTap: (country) => close(context, country),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return CountrySearchList(
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
