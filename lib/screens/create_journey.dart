import 'package:bucket_map/blocs/journeys/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateJourneyScreen extends StatefulWidget {
  @override
  State createState() => _CreateJourneyScreenState();
}

class _CreateJourneyScreenState extends State<CreateJourneyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Neue Reise hinzufügen'),
        actions: [
          TextButton(
            child: Text("Speichern"),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Land',
              ),
            ),
            SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Begin',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ende',
                    ),
                  ),
                )
              ],
            )
          ],
        ),
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
    );
  }
}
