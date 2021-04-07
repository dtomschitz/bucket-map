import 'package:bucket_map/models/country.dart';
import 'package:flutter/material.dart';
import 'package:bucket_map/modules/trips/trips.dart';

class AllTripList extends StatefulWidget {
  const AllTripList({Key key}) : super(key: key);

  @override
  State createState() => _AllTripListState();
}

class _AllTripListState extends State<AllTripList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: trips.length,
      itemBuilder: (BuildContext context, int index) {
        final trip = trips[index];
        return TripCard(trip: trip);
      },
    );
  }
}

class TripCard extends StatelessWidget {
  final Trip trip;
  TripCard({this.trip});

  @override
  Widget build(BuildContext context) {
    final country = countries[this.trip.country];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return TripScreen(trip: this.trip);
          }));
        },
        child: Container(
          height: 250,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  trip.titleImage,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(color: Color.fromARGB(50, 0, 0, 0)),
              ),
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        trip.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //Spacer(),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '12.10.2021',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.place_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                country.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
