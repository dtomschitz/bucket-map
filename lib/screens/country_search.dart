import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/models/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountrySearchScreen extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // return Container();

    return BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
      final CountriesBloc countriesBloc =
          BlocProvider.of<CountriesBloc>(context);

      List<Country> list = [];
      if (state == CountriesLoading() || state == CountriesUninitialized()) {
        list = [];
      } else {
        list = (countriesBloc.state as CountriesLoaded).countries;
      }

      final filteredList = query.isEmpty
          ? list
          : list
              .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

      return ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final Country listItem = filteredList[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://flagcdn.com/w160/${listItem.code.toLowerCase()}.png',
                ),
                backgroundColor: Colors.grey.shade100,
              ),
              title: Text(listItem.name),
              trailing: Icon(
                Icons.remove_red_eye,
                color: Colors.black,
              ),
            );
          });
    });
  }
}
