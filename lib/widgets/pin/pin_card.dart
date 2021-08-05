part of widgets;

class LocationCard extends StatelessWidget {
  LocationCard(this.pin);
  final Pin pin;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(16));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: 2,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isDismissible: true,
              builder: (BuildContext context) {
                return LocationCardBottomSheet(pin);
              },
            );
          },
          child: ListTile(
            leading: Icon(Icons.place),
            title: Text(pin.name),
          ),
        ),
      ),
    );
  }
}
