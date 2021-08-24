part of screens;

class UnlockedCountriesScreen extends StatefulWidget {
  static show(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) => UnlockedCountriesScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State createState() => _UnlockedCountriesScreenState();
}

class _UnlockedCountriesScreenState extends State<UnlockedCountriesScreen> {
  final TextEditingController _searchController = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FilteredCountriesBloc, FilteredCountriesState>(
        builder: (context, state) {
          if (state is FilteredCountriesLoaded) {
            return CustomScrollView(
              slivers: [
                UnlockedCountriesAppBar(
                  scrollController: _scrollController,
                  searchController: _searchController,
                ),
                UnlockedCountriesList(countries: state.countries)
              ],
            );
          }

          return CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              UnlockedCountriesAppBar(
                scrollController: _scrollController,
                searchController: _searchController,
              ),
              SliverList(
                  delegate: SliverChildListDelegate.fixed([
                TopCircularProgressIndicator(),
              ]))
            ],
          );
        },
      ),
    );
  }
}

class UnlockedCountriesAppBar extends StatelessWidget {
  UnlockedCountriesAppBar({this.scrollController, this.searchController});

  final ScrollController scrollController;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      leading: IconButton(
        icon: Icon(Icons.close_outlined),
        onPressed: () {
          BlocProvider.of<FilteredCountriesBloc>(context)
              .add(ClearCountriesFilter());
          Navigator.pop(context);
        },
      ),
      title: SearchBarContainer(
        child: TextField(
          controller: searchController,
          decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: Icon(Icons.search_rounded),
            hintText: 'Suchen',
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onChanged: (value) {
            scrollController.animateTo(
              0,
              duration: Duration(milliseconds: 250),
              curve: Curves.ease,
            );

            BlocProvider.of<FilteredCountriesBloc>(context)
                .add(UpdateCountriesFilter(value));
          },
        ),
      ),
    );
  }
}

class UnlockedCountriesList extends StatelessWidget {
  UnlockedCountriesList({this.countries});
  final List<Country> countries;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final country = countries[index];
          final isUnlocked = country.unlocked;

          final icon = Icon(
            isUnlocked ? Icons.lock_open_outlined : Icons.lock_outline,
            color: isUnlocked ? Colors.green : Colors.grey,
          );

          return CountryListTile(
            country: country,
            onTap: () {
              if (isUnlocked) {
                UnlockedCountryBottomSheet.show(context, country);
              } else {
                BlocProvider.of<ProfileBloc>(context)
                    .add(UnlockCountry(country.code));
              }
            },
            trailing: icon,
          );
        },
        childCount: countries.length,
      ),
    );
  }
}
