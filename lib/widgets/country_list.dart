import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryList extends StatelessWidget {
  const CountryList({Key key, this.controller}) : super(key: key);

  final ScrollController controller;

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
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: countries.length,
              itemBuilder: (BuildContext context, int index) {
                return CountryListItem(country: countries[index]);
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
  const CountryListItem({this.country});

  final Country country;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://flagcdn.com/w160/${country.code.toLowerCase()}.png',
        ),
        backgroundColor: Colors.grey.shade100,
      ),
      title: Text(country.name),
      trailing: Icon(
        Icons.lock_outlined,
        color: Colors.black,
      ),
      onTap: () {
        
      },
    );
  }
}
