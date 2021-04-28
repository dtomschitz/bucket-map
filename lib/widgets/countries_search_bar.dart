import 'package:flutter/material.dart';

enum CountriesSearchBarType { elevated, flat }

class CountriesSearchBar extends StatelessWidget {
  CountriesSearchBar({this.type});

  final CountriesSearchBarType type;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: type == CountriesSearchBarType.elevated
            ? BorderSide(color: Colors.white, width: 1.0)
            : BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: type == CountriesSearchBarType.elevated ? 4 : 0,
      child: Container(
        height: 46,
        width: double.infinity,
        padding: EdgeInsets.only(right: 16, left: 16),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.search_outlined),
            ),
            Text('Search')
          ],
        ),
      ),
    );
  }
}
