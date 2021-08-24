part of widgets;

class CountrySearchList extends StatefulWidget {
  CountrySearchList({
    this.query,
    this.filterOnlyUnlocked,
    this.onTap,
  });

  final String query;
  final bool filterOnlyUnlocked;

  final Function(Country country) onTap;

  @override
  State createState() => CountrySearchListState();
}

class CountrySearchListState extends State<CountrySearchList> {
  @override
  initState() {
    super.initState();

    var bloc = BlocProvider.of<CountriesBloc>(context);
    if (bloc.state is CountriesUninitialized) {
      bloc.add(LoadCountries());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesBloc, CountriesState>(
      builder: (context, state) {
        if (state is CountriesLoaded) {
          List<Country> countries = state.countries.where(
            (country) {
              return widget.filterOnlyUnlocked
                  ? country.name
                          .toLowerCase()
                          .contains(widget.query.toLowerCase()) &&
                      country.unlocked
                  : country.name
                      .toLowerCase()
                      .contains(widget.query.toLowerCase());
            },
          ).toList();

          return CountryList(
            countries: countries,
            onTap: (country) {
              if (country != null) {
                widget.onTap?.call(country);
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
