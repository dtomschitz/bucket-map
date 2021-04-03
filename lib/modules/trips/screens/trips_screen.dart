import 'package:bucket_map/modules/trips/trips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meine Reisen',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: AllTripList(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_trip',
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
