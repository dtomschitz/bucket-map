import 'package:flutter/material.dart';
import 'package:bucket_map/modules/countries/countries.dart';

class CountryList extends StatefulWidget {
  const CountryList({Key key}) : super(key: key);

  @override
  State createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: countries.length,
      itemBuilder: (BuildContext context, int index) {
        final country = countries[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage('https://flagcdn.com/w160/${country.code}.png'),
            backgroundColor: Colors.grey.shade100,
          ),
          title: Text(country.name),
          trailing: Icon(
            country.unlocked ? Icons.lock_open_outlined : Icons.lock_outline,
            color: country.unlocked ? Colors.green.shade500 : Colors.black,
          ),
          onTap: () {
            setState(() {
              countries[index].unlocked = true;
            });
          },
        );
      },
    );
  }
}
