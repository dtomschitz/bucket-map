import 'package:flutter/widgets.dart';
import 'package:fluro/fluro.dart';

import 'package:bucket_map/modules/trips/trips.dart';


/*var dashboardHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return DashboardScreen();
  }
);

var countriesHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return CountryListScreen();
  }
);

var profileHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ProfileScreen();
  }
);*/

var tripHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return TripScreen();
  }
);