import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryList extends StatelessWidget {
  const CountryList({Key key, this.controller, this.buildTrailing, this.onTap}) : super(key: key);

  final ScrollController controller;
  final Widget Function(Country country) buildTrailing;
  final Function(Country country) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
          if (state is CountriesLoaded) {
            List<Country> countries = state.countries;
            return ListView.builder(
              key: GlobalKeys.countriesSheetList,
              controller: controller,
              padding: EdgeInsets.only(top: 8, bottom: 8),
              shrinkWrap: true,
              itemCount: countries.length,
              itemBuilder: (BuildContext context, int index) {
                final country = countries[index];
                return CountryListItem(
                  country: country,
                  //trailing: buildTrailing(country),
                  //onTap: onTap(country),
                );
              },
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class CountryListItem extends StatelessWidget {
  const CountryListItem({this.country, this.trailing, this.onTap});

  final Country country;
  final Widget trailing;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final code = country.code.toLowerCase();

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://flagcdn.com/w160/$code.png'),
        backgroundColor: Colors.grey.shade100,
      ),
      title: Text(country.name),
      //trailing: trailing,
      onTap: onTap,
    );
  }
}
