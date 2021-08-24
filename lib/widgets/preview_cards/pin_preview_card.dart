part of widgets;

class PinPreviewCard extends StatelessWidget {
  PinPreviewCard({
    @required this.coordinates,
    this.height = 215,
    this.elevation = 6.0,
    this.padding = const EdgeInsets.all(0),
    this.onTap,
  });

  final LatLng coordinates;

  final double height;
  final double elevation;
  final EdgeInsets padding;

  final Function() onTap;
  final MapController controller = MapController();

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(16));

    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: elevation,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Map(
              controller: controller,
              initialCameraPosition: CameraPosition(
                target: coordinates,
                zoom: 12,
              ),
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              disableUserLocation: true,
              onMapCreated: () async {
                //await controller.setUnlockedCountries([country.code]);
                await controller.addPin(coordinates);
                Future.delayed(const Duration(milliseconds: 200), () async {
                  await controller.moveCameraToPosition(coordinates, zoom: 10);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
