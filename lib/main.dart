import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';
//import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:iso_countries/iso_countries.dart';
import 'package:latlong/latlong.dart';
//import 'package:latlng/latlng.dart';
//import 'package:country_picker/country_picker.dart';
//import 'package:country_provider/country_provider.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo.shade900, //fromRGBO(22, 33, 49, 0.9),
        accentColor: Colors.blue,
      ),
      title: 'Bucket Map',
      home: HomeScreenGenerator(),
    );
  }
}

class HomeScreenGenerator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreenGenerator> {
  int adding = 0;

  List<Marker> savedMarkers = [
    Marker(
      point: LatLng(48.775845, 9.1829317),
      builder: (ctx) => new Container(
        child: Icon(
          Icons.location_on,
          color: Colors.red,
        ),
      ),
    ),
    Marker(
      point: LatLng(48.773, 9.180),
      builder: (ctx) => new Container(
        child: Icon(
          Icons.location_on,
          color: Colors.red,
        ),
      ),
    ),
    Marker(
      point: LatLng(48.6824763, 9.6278439),
      builder: (ctx) => new Container(
        child: Icon(
          Icons.location_on,
          color: Colors.red,
        ),
      ),
    ),
  ];

  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((result) {
      setState(() {
        _currentPosition = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bucket Map'),
      ),
      body: build_whole_body(context),
    );
  }

  @override
  Widget build_whole_body(BuildContext context) {
    return Stack(
      children: [
        Expanded(
          child: build_map_future(context),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => {
                adding++,
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddScreenGenerator(),
                  ),
                )
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 4.0),
            child: FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchScreenGenerator()),
                )
              },
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.only(right: 4.0, top: 4.0, bottom: 2.0),
                  child: FloatingActionButton(child: Icon(Icons.settings))),
              Padding(
                padding: const EdgeInsets.only(right: 4.0, top: 2.0),
                child: FloatingActionButton(
                  child: Icon(Icons.gps_fixed),
                  onPressed: () => {
                    Geolocator()
                        .getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.best)
                        .then((result) {
                      print(result);
                    })
                  },
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment(0.5, 0.975),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              decoration: new BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.circular(40),
              ),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 4.0, top: 4.0, bottom: 4.0),
                  child: FloatingActionButton(
                    child: Icon(Icons.map),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 4.0, right: 16.0, top: 4.0, bottom: 4.0),
                  child: FloatingActionButton(
                    child: Icon(Icons.list),
                    backgroundColor: Colors.blue, //grey
                    foregroundColor: Colors.black,
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ListScreenGenerator()), // ListScreenGenerator()),
                      ),
                    },
                  ),
                ),
              ]),
            )
          ]),
        )
      ],
    );
  }

  @override
  Widget build_map_future(BuildContext context) {
    return FutureBuilder<Position>(
      future: getCurrentLocation(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        print(snapshot.connectionState);
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Align(
            child: CircularProgressIndicator(),
            alignment: Alignment.center,
          );
        } else {
          return new FlutterMap(
            options: new MapOptions(
                //center: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                center: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                minZoom: 10.0),
            layers: [
              new TileLayerOptions(
                  //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/florian9930/ckmvov7hz0qb917o9vkafvntu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZmxvcmlhbjk5MzAiLCJhIjoiY2ttdm9zNjdjMDdidjJ3cWl0cGhiYWFqdyJ9.wpHxQpwQgd2q-7PsVC2wTw',
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiZmxvcmlhbjk5MzAiLCJhIjoiY2ttdm9zNjdjMDdidjJ3cWl0cGhiYWFqdyJ9.wpHxQpwQgd2q-7PsVC2wTw',
                    'id':
                        'mapbox://styles/florian9930/ckmvov7hz0qb917o9vkafvntu'
                  }),
              new MarkerLayerOptions(markers: savedMarkers)
            ],
          );
        }
      },
    );
  }

  Future<Position> getCurrentLocation() async {
    Position new_pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(new_pos);
    return new_pos;
  }
}

class SearchScreenGenerator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreenGenerator> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bucket Map (List View)'),
        ),
        body: build_whole_body(context),
        backgroundColor: Colors.grey.shade900);
  }

  @override
  Widget build_whole_body(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Flexible(
            child: TextField(
              controller: myController,
              textAlign: TextAlign.center,
              autofocus: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: Colors.grey.shade800,
                filled: true,
                hintText: 'Search',
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide.none),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () => {
              Fluttertoast.showToast(
                msg: myController.text,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                //timeInSecForIos: 1
              )
            },
          ),
        ]),
      ],
    );
  }
}

class AddScreenGenerator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddScreen();
}

class _AddScreen extends State<AddScreenGenerator> {
  //Future<List<Country>> _countries;
  // Future get_all_countries() async {
  //   List<Country> countries = await CountryProvider.getAllCountries();
  //   return countries;
  // }

  List<String> continents = [
    'Asien',
    'Afrika',
    'Nordamerika',
    'Südamerika',
    'Antarktis',
    'Europa',
    'Australien und Ozeanien'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bucket Map (Add Location View)'),
        ),
        body: build_whole_body(context), //_build_body(),,
        backgroundColor: Colors.indigo.shade900);
  }

  @override
  Widget build_whole_body(BuildContext context) {
    //return Column(children: [Text('First'), Text('second')]);
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(hintText: 'Straße / Hausnummer'),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(hintText: 'Postleitzahl / Stadt'),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(hintText: 'Land'),
        ),
        SizedBox(height: 20),
        Text(
            'Für eine genauere Lokalisierung kann der Breiten- und Höhengrad angegeben werden oder der genaue aktuelle Standort genutzt werden.'),
        SizedBox(height: 20),
        Row(children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Breitengrad',
              ),
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Höhengrad',
              ),
            ),
          ),
          Expanded(
            child: FloatingActionButton(
              child: Icon(Icons.location_searching),
              onPressed: () => {
                Geolocator()
                    .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
                    .then((result) {
                  print(result);
                })
                //print(Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position position)))
              },
            ),
          )
        ]),
        Row(children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
          ),
          Align(
            child: FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () => {print('save button pressed')},
            ),
          )
        ]),
      ],
    );
  }
}

class ListScreenGenerator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListScreen();
}

class _ListScreen extends State<ListScreenGenerator> {
  //Future<List<Country>> _countries;
  List<String> continents = [
    'Asien',
    'Afrika',
    'Nordamerika',
    'Südamerika',
    'Antarktis',
    'Europa',
    'Australien und Ozeanien'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bucket Map (List View)'),
        ),
        body: build_whole_body(context),
        backgroundColor: Colors.indigo.shade900);
  }

  @override
  Widget build_whole_body(BuildContext context) {
    return Stack(children: [
      GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        // crossAxisSpacing: 10,
        // mainAxisSpacing: 10,
        children: continents.map((value) {
          return Container(
            height: 10,
            width: 1,
            alignment: Alignment.center,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text("${value}"),
          );
        }).toList(),
      ),
      Align(
        alignment: Alignment(0.5, 0.975),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            decoration: new BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.circular(40)),
            child: Row(children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 4.0, top: 4.0, bottom: 4.0),
                  child: FloatingActionButton(
                    child: Icon(Icons.map),
                    backgroundColor: Colors.blue, //grey
                    foregroundColor: Colors.white,
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenGenerator()),
                      )
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(
                    left: 4.0, right: 16.0, top: 4.0, bottom: 4.0),
                child: FloatingActionButton(
                  child: Icon(Icons.list),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ]),
          )
        ]),
      )
    ]);
  }

  @override
  Widget build_whole_body_old(BuildContext context) {
    return Stack(children: [
      CountryListPick(
        onChanged: (CountryCode code) {},
      ),
      Align(
        alignment: Alignment(0.5, 0.975),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            decoration: new BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.circular(40)),
            child: Row(children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 4.0, top: 4.0, bottom: 4.0),
                  child: FloatingActionButton(
                    child: Icon(Icons.map),
                    backgroundColor: Colors.blue, //grey
                    foregroundColor: Colors.white,
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenGenerator()),
                      )
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(
                    left: 4.0, right: 16.0, top: 4.0, bottom: 4.0),
                child: FloatingActionButton(
                  child: Icon(Icons.list),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ]),
          )
        ]),
      )
    ]);
  }
}
