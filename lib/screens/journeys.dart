import 'package:bucket_map/blocs/journeys/bloc.dart';
import 'package:bucket_map/screens/create_journey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JourneysScreen extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: JourneysScreen());

  @override
  State createState() => _JourneysScreenState();
}

class _JourneysScreenState extends State<JourneysScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Meine Reisen'),
      ),
      /*body: BlocBuilder<JourneysBloc, JourneysState>(
        builder: (context, state) {
          return ListView(
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      leading: Icon(Icons.album),
                      title: Text('The Enchanted Nightingale'),
                      subtitle:
                          Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),*/
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => CreateJourneyScreen(),
            ),
          );
        },
      ),
    );
  }
}
