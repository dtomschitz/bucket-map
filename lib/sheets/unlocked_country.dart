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
          leading: Container(
            height: double.infinity,
            child: Icon(Icons.star),
          ),
          title: Text('Du hast dieses Land am .. freigeschalten'),
        ),
        LocationListTile(
          title: Text('Geographische Koordinaten'),
          coordinates: country.latLng,
        ),
      ],
    );
  }
}
