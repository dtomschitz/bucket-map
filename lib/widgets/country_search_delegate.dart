import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountrySearchDelegate extends SearchDelegate<Country> {
  CountrySearchDelegate({bool filterOnlyUnlocked})
      : filterOnlyUnlocked = filterOnlyUnlocked ?? false;

  final bool filterOnlyUnlocked;

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
  String get searchFieldLabel => 'Nach Land suchen';
}

class _CountrySearchList extends StatelessWidget {
  _CountrySearchList({this.query, this.filterOnlyUnlocked, this.onTap});

  final String query;
  final bool filterOnlyUnlocked;

  final Function(Country country) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          List<Country> countries = state.countries.where(
            (country) {
              return filterOnlyUnlocked
                  ? country.name.toLowerCase().contains(query.toLowerCase()) &&
                      country.unlocked
                  : country.name.toLowerCase().contains(query.toLowerCase());
            },
          ).toList();

          return CountryList(
            countries: countries,
            onTap: (country) {
              if (country != null) {
                onTap?.call(country);
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
