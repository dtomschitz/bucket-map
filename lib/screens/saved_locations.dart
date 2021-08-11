part of screens;

class SavedLocationsScreen extends StatefulWidget {
  SavedLocationsScreen({Key key}) : super(key: key);

  @override
  State createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  bool _countriesLoaded = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CountriesBloc, CountriesState>(
      listener: (context, state) {
        if (state is CountriesLoaded) {
          setState(() => _countriesLoaded = true);
        }
      },
      builder: (context, state) {
        final unlockedCountries =
            state is CountriesLoaded ? state.unlockedCountries : [];
        final recentUnlockedCountries =
            state is CountriesLoaded ? state.recentUnlockedCountries : [];

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text('Deine Länder'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search_outlined),
                    onPressed: () async {
                      final country = await CountrySearch.show(context);
                      if (country != null) {
                        openCountry(country);
                      }
                    },
                  )
                ],
              ),
              SliverListHeader('Zuletzt freigeschalten'),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final country = recentUnlockedCountries[index];

                    return CountryListTile(
                      country: country,
                      onTap: () => openCountry(country),
                      showUnlockedDate: true,
                    );
                  },
                  childCount: recentUnlockedCountries.length,
                ),
              ),
              SliverListHeader('Freigeschalten'),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final country = unlockedCountries[index];

                    return CountryListTile(
                      country: unlockedCountries[index],
                      onTap: () => openCountry(country),
                      showUnlockedDate: true,
                    );
                  },
                  childCount: unlockedCountries.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  openCountry(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryMap(country: country),
      ),
    );
  }
}

class SliverListHeader extends StatelessWidget {
  SliverListHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headline6;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
