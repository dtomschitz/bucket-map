part of widgets;

class LocationListTile extends StatelessWidget {
  LocationListTile({this.title, this.coordinates});

  final Widget title;
  final LatLng coordinates;

  @override
  Widget build(BuildContext context) {
    final latitude = coordinates.latitude;
    final longitude = coordinates.longitude;

    return ListTile(
      /*leading: CircleAvatar(
        //height: double.infinity,
        backgroundColor: Colors.transparent,
        //foregroundColor: Colors.white,
        child: Icon(Icons.place_outlined),
      ),*/
      leading: Icon(Icons.place_outlined),
      title: title,
      subtitle: Text('$latitude, $longitude'),
      onTap: () {
        var data = ClipboardData(text: '$latitude, $longitude');
        Clipboard.setData(data);

        showSnackbar(context, () => CopyToClipboardSnackBar());
      },
    );
  }
}
