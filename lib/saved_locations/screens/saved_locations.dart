part of saved_locations.screens;

class SavedLocationsScreen extends StatefulWidget {
  SavedLocationsScreen({Key key}) : super(key: key);

  @override
  State createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gespeichert'),
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
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            final countries = state.profile.unlockedCountries
                .map(
                  (code) => state.countries.firstWhere(
                    (country) => country.code == code,
                  ),
                )
                .toList();

            return CountryList(
              controller: ScrollController(),
              shrinkWrap: false,
              countries: countries,
              onTap: openCountry,
              buildTrailing: (country) {
                return Icon(Icons.arrow_forward_ios_outlined);
              },
            );
          }

          return Container();
        },
      ),
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
