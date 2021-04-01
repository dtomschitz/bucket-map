import 'package:bucket_map/modules/countries/delegates/country_search.dart';
import 'package:bucket_map/modules/countries/widgets/map.dart';
import 'package:bucket_map/modules/countries/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  @override
  State createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapKey = GlobalKey();
  bool _showMap = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showMap
          ? null
          : AppBar(
              title: Text('Bucket Map', style: TextStyle(color: Colors.black),),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: CountrySearch());
                  },
                ),
              ],
            ),
      body: _showMap ? Map(key: mapKey) : SafeArea(child: CountryList()),
      floatingActionButton: FloatingActionButton(
        child: Icon(_showMap ? Icons.list_outlined : Icons.map_outlined),
        onPressed: () {
          setState(() => _showMap = !_showMap);
        },
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
    );
  }
}
