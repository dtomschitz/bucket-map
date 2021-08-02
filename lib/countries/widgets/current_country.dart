part of countries.widgets;

class CurrentCountry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapController = Provider.of<CountriesMapController>(context);

    return StreamBuilder<CameraPosition>(
      stream: mapController.cameraPosition,
      builder: (context, snapshot) {
      

        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.grey.withOpacity(.32),
            ),
            padding: EdgeInsets.all(8),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return Row(
                  children: [
                    SizedBox(
                      width: 26,
                      height: 26,
                      child: CountryAvatar('de'),
                    ),
                    Expanded(
                      child: Text(
                        'Deutschland',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
