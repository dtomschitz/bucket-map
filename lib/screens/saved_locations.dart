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
                      final country = await CountrySearch.show(
                        context,
                        filterOnlyUnlocked: true,
                      );
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
                    return SavedLocationListTile(country: country);
                  },
                  childCount: recentUnlockedCountries.length,
                ),
              ),
              SliverListHeader('Freigeschalten'),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final country = unlockedCountries[index];
                    return SavedLocationListTile(country: country);
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

class SavedLocationListTile extends StatelessWidget {
  SavedLocationListTile({this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).scaffoldBackgroundColor;

    return Material(
      child: OpenContainer(
        openElevation: 0,
        closedElevation: 0,
        closedColor: color,
        openColor: color,
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (context, closeContainer) {
          return CountryMap(country: country);
        },
        tappable: false,
        closedBuilder: (context, openContainer) {
          return CountryListTile(
            country: country,
            onTap: openContainer,
            showUnlockedDate: true,
          );
        },
      ),
    );
  }
}
