part of countries.screens;

class CreateLocationScreen extends StatelessWidget {
  final CountriesMapController mapController = new CountriesMapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Ziel auswählen'),
      ),
      body: CountriesMap(
        controller: mapController,
        onMapClick: (point, position) async {
          Symbol symbol = await mapController.addLocation(
            position,
            clearBefore: true,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaveLocation(symbol),
            ),
          );
        },
      ),
    );
  }
}

class SaveLocation extends StatefulWidget {
  SaveLocation(this.symbol);
  final Symbol symbol;

  @override
  State createState() => _SaveLocationState();
}

class _SaveLocationState extends State<SaveLocation> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  City _city;
  Country _country;

  @override
  void initState() {
    super.initState();
    calculateNearestCity(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Ziel speichern'),
        actions: [
          TextButton(
            child: Text('Speichern'),
            onPressed: () async {
              final location = Location(
                name: nameController.text,
                country: _city.country,
                lat: widget.symbol.options.geometry.latitude,
                lng: widget.symbol.options.geometry.longitude,
              );

              BlocProvider.of<LocationsBloc>(context).add(
                AddLocation(location: location),
              );

              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded && _city != null) {
            return ListViewContainer(
              title: 'Weitere Informationen',
              subtitle:
                  'Um die Location zu speichern, muss noch ein Name festgelegt werden.',
              children: [
                InputField(
                  controller: nameController,
                  labelText: 'Name',
                ),
                SizedBox(height: 32),
              ],
            );
          }

          return TopCircularProgressIndicator();
        },
      ),
    );
  }

  calculateNearestCity(Symbol symbol) async {
    final geo = GeoJson();

    final data = await rootBundle.loadString('assets/countries.geojson');
    await geo.parse(data, verbose: true, nameProperty: 'ADMIN');

    final pinLocation = GeoJsonPoint(
        geoPoint: gp.GeoPoint(
            latitude: symbol.options.geometry.latitude,
            longitude: symbol.options.geometry.longitude),
        name: symbol.id);

 
    // for (var polygon in geo.polygons.where((element) => element.name.allMatches('Germany')) {
    //   final data =
    //       await geo.geofencePolygon(polygon: polygon, points: [pinLocation]);
    //   if (data.isNotEmpty) print(polygon);
    //   print(polygon.name);
    // }
  

    List<dynamic> json = jsonDecode(
      await rootBundle.loadString('assets/cities_3.json'),
    );

    List<City> cities = json.map((c) => City.fromJson(c)).toList();
    City city;

    double lowestDistance = 5000000;
    double distance;
    var cityListIter = cities.iterator;

    while (cityListIter.moveNext()) {
      distance = Geolocator.distanceBetween(
        cityListIter.current.latLng.latitude,
        cityListIter.current.latLng.longitude,
        symbol.options.geometry.latitude,
        symbol.options.geometry.longitude,
      );

      if (distance < lowestDistance) {
        lowestDistance = distance;
        city = cityListIter.current;
      }
    }



    print("XXXXXXXXXXXXXXXXXXXXXXXXXXX");
    var geofencedCity = await geo.geofencePolygon(polygon: geo.polygons.where((element) => element.name==city.isoA3).elementAt(0), points: [pinLocation]);
    if (geofencedCity.isNotEmpty){
      print("Correct Country");
    }

    setState(() => _city = city);
  }
}
