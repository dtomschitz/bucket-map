part of widgets;

class LocationCard extends StatelessWidget {
  LocationCard(this.pin, {this.onTap});

  final Pin pin;
  final VoidCallback onTap;

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
          onTap: onTap?.call,
          child: ListTile(
            leading: Icon(Icons.place),
            title: Text(pin.name),
          ),
        ),
      ),
    );
  }
}
