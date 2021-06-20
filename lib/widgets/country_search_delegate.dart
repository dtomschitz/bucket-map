import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountrySearchDelegate extends SearchDelegate<Country> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
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

          return ListView.builder(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            itemCount: countries.length,
            itemBuilder: (BuildContext context, int index) {
              final country = countries[index];
              final code = country.code.toLowerCase();

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://flagcdn.com/w160/$code.png'),
                  backgroundColor: Colors.grey.shade100,
                ),
                title: Text(country.name),
                onTap: () => onTap?.call(country),
              );
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
