import 'dart:ui';

import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/config/routes/routes.dart';
import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:bucket_map/modules/profile/services/auth.dart';

class CountriesScreen extends StatefulWidget {
  @override
  State createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final mapKey = GlobalKey();
  final AuthService _auth = AuthService();

  final GlobalKey _scaffoldKey = GlobalKey();

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
          child: SlidingUpPanel(
            backdropEnabled: true,
            panelSnapping: true,
            snapPoint: 0.5,
            maxHeight: screenHeight * 1,
            onPanelSlide: (double pos) => setState(() {
              print(pos);
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
            panel: Center(
              child: Text("This is the sliding Widget"),
            ),
            collapsed: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: radius,
              ),
              child: Center(
                child: Text(
                  "This is the collapsed Widget",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            body: Scaffold(
              appBar: AppBar(
                actions: [
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
                  FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('logout'),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
              body: CountriesMap(
                key: mapKey,
                fabHeight: _fabHeight,
              ),
            ),
            borderRadius: radius,
          ),
        );
      },
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesBloc, CountriesState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SlidingSheet(
            duration: const Duration(milliseconds: 900),
            controller: controller,
            color: Colors.white,
            shadowColor: Colors.black26,
            elevation: 12,
            maxWidth: 500,
            cornerRadius: 16,
            cornerRadiusOnFullscreen: 0.0,
            closeOnBackdropTap: true,
            closeOnBackButtonPressed: true,
            addTopViewPaddingOnFullscreen: true,
            isBackdropInteractable: true,
            snapSpec: SnapSpec(
              snap: true,
              positioning: SnapPositioning.relativeToAvailableSpace,
              snappings: const [
                SnapSpec.headerFooterSnap,
                SnapSpec.expanded,
              ],
            ),
            liftOnScrollHeaderElevation: 12.0,
            body: CountriesMap(),
            headerBuilder: buildHeader,
            builder: buildChild,
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader(BuildContext context, SheetState state) {
    offset = state.currentScrollOffset;
    print(offset);
    print(state.currentScrollOffset);
    return CustomContainer(
      key: _scaffoldKey,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shadowColor: Colors.black12,
      height: 80,
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

  Widget buildChild(BuildContext context, SheetState state) {
    print(state.currentScrollOffset);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        /*for (var country in countries)
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://flagcdn.com/w160/${country.code}.png',
              ),
              backgroundColor: Colors.grey.shade100,
            ),
            title: Text(country.name),
            trailing: Icon(
              Icons.lock_open_outlined,
              color: Colors.black,
            ),
            onTap: () {},
          )*/
      ],
    );
  }
  */
}
