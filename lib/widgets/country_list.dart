import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryList extends StatefulWidget {
  const CountryList({Key key}) : super(key: key);

  @override
  State createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
      List<Country> countries =
          (BlocProvider.of<CountriesBloc>(context).state as CountriesLoaded)
              .countries;

      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: countries.length,
        itemBuilder: (BuildContext context, int index) {
          return CountryListItem(country: countries[index]);
        },
      );
    });
  }
}

class CountryListItem extends StatelessWidget {
  final Country country;
  const CountryListItem({this.country});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://flagcdn.com/w160/${country.code}.png',
        ),
        backgroundColor: Colors.grey.shade100,
      ),
      title: Text(country.name),
      trailing: Icon(
        Icons.lock_open_outlined,
        color: Colors.black,
      ),
    );
  }
}
