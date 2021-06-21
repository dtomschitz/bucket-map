import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

class CountryList extends StatelessWidget {
  const CountryList({
    Key key,
    this.controller,
    this.physics,
    this.padding,
    this.countries,
    this.buildTrailing,
    this.onTap,
  }) : super(key: key);

  final ScrollController controller;
  final ScrollPhysics physics;
  final EdgeInsets padding;
  final List<Country> countries;

  final Widget Function(Country country) buildTrailing;
  final void Function(Country country) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: GlobalKeys.countriesSheetList,
      controller: controller,
      padding: padding ?? EdgeInsets.only(top: 8, bottom: 8),
      shrinkWrap: true,
      itemCount: countries.length,
      physics: physics,
      itemBuilder: (BuildContext context, int index) {
        final country = countries[index];
        final code = country.code.toLowerCase();

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://flagcdn.com/w160/$code.png'),
            backgroundColor: Colors.grey.shade100,
          ),
          title: Text(country.name),
          onTap: () => onTap(country),
          trailing: buildTrailing != null ? buildTrailing(country) : null,
        );
      },
    );
  }
}

class FilterdCountriesList extends StatelessWidget {
  FilterdCountriesList({this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredCountriesBloc, FilteredCountriesState>(
      builder: (context, state) {
        if (state is FilteredCountriesLoaded) {
          return GroupedListView<Country, int>(
            elements: state.countries,
            controller: controller,
            scrollDirection: Axis.vertical,
            //shrinkWrap: true,
            groupBy: (country) => country.unlocked ? 0 : 1,
            groupHeaderBuilder: (country) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  country.unlocked
                      ? 'Freigeschaltene Länder'
                      : 'Gesperrte Länder',
                  style: Theme.of(context).textTheme.headline4,
                ),
              );
            },
            itemBuilder: (context, country) => CountryListItem(
              country: country,
              onTap: () {
                if (country.unlocked) {
                  //TODO: open country screen
                } else {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(UnlockCountry(country.code));
                }
              },
              trailing: country.unlocked
                  ? Icon(Icons.arrow_forward_ios_outlined)
                  : Icon(Icons.lock_outline),
            ),
            itemComparator: (a, b) => a.name.compareTo(b.name), // optional
          );
        }

        return Container();
      },
    );
  }
}

class CountryListItem extends StatelessWidget {
  CountryListItem({this.country, this.onTap, this.trailing});

  final Country country;
  final Widget trailing;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final code = country.code.toLowerCase();

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://flagcdn.com/w160/$code.png'),
        backgroundColor: Colors.grey.shade100,
      ),
      title: Text(country.name),
      onTap: () => onTap?.call(),
      trailing: trailing != null ? trailing : null,
    );
  }
}
