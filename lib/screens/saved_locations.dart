import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/screens/country_screen.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedLocationsScreen extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: SavedLocationsScreen());

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
              final country = await showSearch(
                context: context,
                delegate: CountrySearchDelegate(filterOnlyUnlocked: true),
              );

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
        builder: (context) => CountryScreen(country: country),
      ),
    );
  }
}
