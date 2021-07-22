part of saved_locations.screens;

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
