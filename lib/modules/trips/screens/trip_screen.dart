import 'package:bucket_map/modules/trips/trips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TripScreen extends StatelessWidget {
  final Trip trip;

  TripScreen({this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text(
          'Irgendwo',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
        backgroundColor: Colors.white,
      ),*/
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              title: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  //mainAxisSize: ,
                  children: [
                    Text(
                      'Irgendwo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              background: Image.network(
                trip.titleImage,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.overlay,
                color: Color.fromARGB(50, 0, 0, 0),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Container(
                          height: 350,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.favorite_outline_sharp),
                                title: Text('Zu favoriten hinzufügen'),
                                onTap: () {},
                              ),
                              Divider(indent: 70,),
                              ListTile(
                                leading: Icon(Icons.edit_outlined),
                                title: Text('Umbennen'),
                                onTap: () {},
                              ),
                              ListTile(
                                leading: Icon(Icons.place_outlined),
                                title: Text('Besuchte Länder anpassen'),
                                onTap: () {},
                              ),
                              ListTile(
                                leading: Icon(Icons.image_outlined),
                                title: Text('Titelbild aktualisieren'),
                                onTap: () {},
                              ),
                              Divider(indent: 70,),
                              ListTile(
                                leading: Icon(Icons.delete_outline),
                                title: Text('Diese Reise löschen'),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SliverToBoxAdapter(
            child: Center(
              child: SizedBox(
                height: 2000,
                child: Text('Scroll to see SliverAppBar in effect .'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_trip',
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
