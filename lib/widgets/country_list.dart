import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryList extends StatelessWidget {
  const CountryList({Key key, this.controller, this.buildTrailing, this.onTap})
      : super(key: key);

  final ScrollController controller;
  final Widget Function(Country country) buildTrailing;
  final void Function(Country country) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<FilteredCountriesBloc, FilteredCountriesState>(
        builder: (context, state) {
          if (state is FilteredCountriesLoaded) {
            List<Country> countries = state.countries;

            return ListView.builder(
              key: GlobalKeys.countriesSheetList,
              controller: controller,
              padding: EdgeInsets.only(top: 8, bottom: 8),
              shrinkWrap: true,
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
                  onTap: () => onTap(country),
                  trailing: buildTrailing(country),
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
      ),
    );
  }
}