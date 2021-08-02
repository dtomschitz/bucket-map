part of countries.screens;

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
  final TextEditingController searchController = new TextEditingController();
  final ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: BlocBuilder<FilteredCountriesBloc, FilteredCountriesState>(
        builder: (context, state) {
          if (state is FilteredCountriesLoaded) {
            return CountryList(
              controller: scrollController,
              countries: state.countries,
              shrinkWrap: false,
              onTap: (country) {
                BlocProvider.of<ProfileBloc>(context)
                    .add(UnlockCountry(country.code));
              },
              disabled: (country) => country.unlocked,
              buildTrailing: (country) {
                return Icon(
                  country.unlocked
                      ? Icons.lock_open_outlined
                      : Icons.lock_outline,
                  color: country.unlocked ? Colors.green : Colors.grey,
                );
              },
            );
          }

          return TopCircularProgressIndicator();
        },
      ),
    );
  }
}
