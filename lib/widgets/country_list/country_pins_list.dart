part of widgets;

class CountryPinsList extends StatelessWidget {
  CountryPinsList({
    this.country,
    this.pins = const [],
    this.onPinChanged,
  });

  final Country country;
  final List<Pin> pins;

  final Function(Pin pin) onPinChanged;

  final PageController _pageController = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 100,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: PageView.builder(
            controller: _pageController,
            itemCount: pins.length,
            onPageChanged: (index) => onPinChanged?.call(pins[index]),
            itemBuilder: (context, index) {
              final pin = pins[index];
              return LocationCard(
                pin,
                onTap: () {
                  EditPinBottomSheet.show(
                    context,
                    pin: pin,
                    country: country,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
