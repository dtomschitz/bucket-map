import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CountryMap extends StatelessWidget {
  CountryMap({this.country, this.pins});

  final Country country;
  final List<Pin> pins;

  final CountriesMapController controller = CountriesMapController();
  final PageController pageController = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(country.name),
      ),
      body: Stack(
        children: [
          CountriesMap(
            controller: controller,
            disableUserLocation: true,
            onMapCreated: () async {
              await controller.setUnlockedCountries([country.code]);
              await controller.addPins(pins);

              Future.delayed(const Duration(milliseconds: 250), () async {
                await controller.animateCameraToCountry(country);
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 100,
              child: SafeArea(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: pins.length,
                  onPageChanged: (index) async {
                    await controller.animateCameraToPin(pins[index]);
                  },
                  itemBuilder: (context, index) {
                    final pin = pins[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.place),
                        title: Text(pin.name),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
