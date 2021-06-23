import 'package:bucket_map/blocs/blocs.dart';
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
      ),
      body: BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, countriesState) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              if (countriesState is CountriesLoaded &&
                  profileState is ProfileLoaded) {
                final countries = profileState.profile.unlockedCountries
                    .map(
                      (code) => countriesState.countries.firstWhere(
                        (country) => country.code == code,
                      ),
                    )
                    .toList();

                return CountryList(
                  controller: ScrollController(),
                  shrinkWrap: false,
                  countries: countries,
                  onTap: (country) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CountryScreen(country: country),
                      ),
                    );
                  },
                  buildTrailing: (country) {
                    return Icon(Icons.arrow_forward_ios_outlined);
                  },
                );
              }

              return Container();
            },
          );
        },
      ),
    );
  }
}
