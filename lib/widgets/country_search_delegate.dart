import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountrySearchDelegate extends SearchDelegate<Country> {
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
      onTap: (country) => close(context, country),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _CountrySearchList(
      query: query,
      onTap: (country) => close(context, country),
    );
  }

  @override
  String get searchFieldLabel => 'Nach Land suchen';
}

class _CountrySearchList extends StatelessWidget {
  _CountrySearchList({this.query, this.onTap});

  final String query;
  final Function(Country country) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesBloc, CountriesState>(
      builder: (context, state) {
        if (state is CountriesLoaded) {
          List<Country> countries = state.countries.where(
            (country) {
              return country.name.toLowerCase().contains(query.toLowerCase());
            },
          ).toList();

          return CountryList(
            countries: countries,
            onTap: (country) {
              print(country);
              if (country != null) {
                onTap?.call(country);
              }
            },
          );
        }

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 16),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
