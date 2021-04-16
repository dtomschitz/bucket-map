import 'dart:ui';

import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/config/routes/routes.dart';
import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:bucket_map/utils/interval.dart';
import 'package:bucket_map/widgets/custom_container.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CountriesScreen extends StatefulWidget {
  @override
  State createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final mapKey = GlobalKey();

  final GlobalKey _scaffoldKey = GlobalKey();
  SheetController controller;

  bool show = false;

  double offset = 0;

  double height;

  double screenHeight;

  bool modfiyPin = false;

  Offset test;

  double _initFabHeight;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modfiyPin = false;
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    screenHeight = MediaQuery.of(context).size.height;
    _initFabHeight = screenHeight * 0.12;
    if (_fabHeight == null) _fabHeight = _initFabHeight;
    _panelHeightOpen = screenHeight * 1;

    return BlocBuilder<CountriesBloc, CountriesState>(
      builder: (context, state) {
        return Material(
            child: SlidingSheet(
                headerBuilder: _buildHeader,
                elevation: 8,
                cornerRadius: 16,
                snapSpec: const SnapSpec(
                  // Enable snapping. This is true by default.
                  snap: true,
                  // Set custom snapping points.
                  snappings: [0.1, 0.4, 1.0],
                  // Define to what the snappings relate to. In this case,
                  // the total available space that the sheet can expand to.
                  positioning: SnapPositioning.relativeToAvailableSpace,
                ),
                // The body widget will be displayed under the SlidingSheet
                // and a parallax effect can be applied to it.
                body: Scaffold(
                  appBar: AppBar(actions: [
                    IconButton(
                      icon: Icon(Icons.settings_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ]),
                  body: CountriesMap(
                    key: mapKey,
                    fabHeight: _fabHeight,
                  ),
                ),
                builder: (context, state) {
                  // This is the content of the sheet that will get
                  // scrolled, if the content is bigger than the available
                  // height of the sheet.
                  return Container(
                    height: 500,
                    child: Center(
                      child: CountryList(),
                    ),
                  );
                }));
      },
    );
  }

  Widget _buildHeader(BuildContext context, SheetState state) {
    return CustomContainer(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shadowColor: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.topCenter,
              child: CustomContainer(
                width: 26,
                height: 4,
                borderRadius: 2,
                color: Colors.grey.withOpacity(
                  .5 * (1 - interval(0.7, 1.0, state.progress)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Freigeschaltene Länder',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '15 von 195 Ländern freigeschaltet',
                  style: TextStyle(
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
