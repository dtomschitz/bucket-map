part of sheets;

class UnlockedCountryBottomSheet extends StatelessWidget {
  UnlockedCountryBottomSheet({this.country});
  final Country country;

  static Future<T> show<T>(BuildContext context, Country country) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return UnlockedCountryBottomSheet(country: country);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      leading: CountryAvatar(country.code),
      title: country.name,
      children: [
        ListTile(
          leading: CenteredIcon(
            icon: Icon(Icons.lock_open_outlined),
          ),
          title: Text(
            'Du hast dieses Land am ${Utils.formatDate(country.dateTime)} freigeschalten',
          ),
        ),
        LocationListTile(
          title: Text('Geographische Koordinaten'),
          coordinates: country.latLng,
        ),
      ],
    );
  }
}
