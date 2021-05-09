//import 'dart:js';

import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

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
        elevation: type == CountriesSearchBarType.elevated ? 8 : 0,
        child: GestureDetector(
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
          onTap: () {
            showSearch(context: context, delegate: CountrySearchScreen());
          },
        ));
  }
}

class FloatingCountriesSearchBar extends StatefulWidget {
  final MapboxMapController mapController;
  final Function(Country country) onClick;
  FloatingCountriesSearchBar({this.mapController, this.onClick});

  @override
  _FloatingCountriesSearchBarState createState() =>
      _FloatingCountriesSearchBarState();
}

class _FloatingCountriesSearchBarState
    extends State<FloatingCountriesSearchBar> {
  bool _showList = true; // false;
  final controller = FloatingSearchBarController();

  Widget build(context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return BlocBuilder<FilteredCountriesBloc, FilteredCountriesState>(
        builder: (context, state) {
      final FilteredCountriesBloc filteredCountriesBloc =
          BlocProvider.of<FilteredCountriesBloc>(context);

      List<Country> countryList = [];
      if (state == FilteredCountriesInitialState() ||
          state == FilteredCountriesFiltering()) {
        countryList = [];
      } else {
        countryList = (filteredCountriesBloc.state as FilteredCountriesFiltered)
            .countries;
      }
      return FloatingSearchBar(
        hint: 'Navigate to country...',
        backdropColor: Colors.transparent,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 0),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        controller: controller,
        automaticallyImplyBackButton: true,
        physics: const ScrollPhysics(), // NeverScrollableScrollPhysics(),
        isScrollControlled: true,
        onQueryChanged: (query) {
          setState(() {
            if (query.length > 2) {
              filteredCountriesBloc
                  .add(FilterCountriesEvent(filterString: query));
              _showList = true;
          } else {
              _showList = false;
          }
          });
        },
        onSubmitted: (query) {
          filteredCountriesBloc.add(FilterCountriesEvent(filterString: query));
          _showList = (query.isNotEmpty);
        },
        clearQueryOnClose: true,
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction.searchToClear(
            showIfClosed: true,
          ),
        ],
        builder: (context, transition) {
          if (_showList) {
            return Material(
                color: Colors.white,
                elevation: 4.0,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: countryList.length,
                    itemBuilder: (context, i) {
                      print(i);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://flagcdn.com/w160/${countryList[i].code.toLowerCase()}.png',
                          ),
                          backgroundColor: Colors.grey.shade100,
                        ),
                        title: Text(countryList[i].name),
                        trailing: Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        ),
                        onTap: () =>
                            {widget.onClick(countryList[i]), controller.close()},
                      );
                    }));
          } else {
            return Container();
          }
        },
      );
    });
  }
}
