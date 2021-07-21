import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/dialogs/dialogs.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryMap extends StatelessWidget {
  CountryMap({this.country});

  final Country country;

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
        title: Text(country.name),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              country.unlocked ? Icons.lock_open_outlined : Icons.lock_outlined,
            ),
          ),
        ],
      ),
      body: BlocBuilder<PinsBloc, PinsState>(
        builder: (context, state) {
          if (state is PinsLoaded) {
            final pins =
                state.pins.where((pin) => pin.country == country.code).toList();

            return Stack(
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
                          return LocationCard(pins[index]);
                        },
                      ),
                    ),
                  ),
                )
              ],
            );
          }

          return TopCircularProgressIndicator();
        },
      ),
    );
  }
}

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

class LocationCardBottomSheet extends StatelessWidget {
  LocationCardBottomSheet(this.pin);
  final Pin pin;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      title: pin.name,
      children: [
        pin.description != null
            ? ListTile(
                leading: Icon(Icons.description_outlined),
                title: Text(pin.description),
              )
            : Container(),
        SizedBox(height: 32),
        ListTile(
          leading: Icon(Icons.edit_outlined),
          title: Text('Bearbeiten'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.map_outlined),
          title: Text('Land ändern'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text('Löschen'),
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) {
                return ConfirmPinDeletionDialog();
              },
            );

            if (confirmed) {}
          },
        ),
      ],
    );
  }
}
