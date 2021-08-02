part of shared.widgets;

class CreatePinBottomSheet extends StatelessWidget {
  CreatePinBottomSheet(this.coordinates);
  final LatLng coordinates;

  static show(BuildContext context, LatLng coordinates) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => CreatePinBottomSheet(coordinates),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PinsBloc, PinsState>(
      builder: (context, state) {
        return BottomSheetContainer(
          title: 'Pin hinzufügen',
          //mainAxisSize: MainAxisSize.max,
          children: [
            /*FutureBuilder(
              future: GeoUtils.getCountryCode(coordinates),
              builder: (context, snapshot) {
                
              },
            )*/
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
              ),
            ),
            CountrySelect(),
            ListTile(
              title: Text('Speichern'),
            )
          ],
        );
      },
    );
  }
}
