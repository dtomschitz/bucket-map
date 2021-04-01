import 'package:flutter/widgets.dart';
import 'package:fluro/fluro.dart';
import './route_handlers.dart';

export 'app_router.dart';

class Routes {
  static String home = "/home";
  static String dashboard = "/dashboard";
  static String search = "/search";
  static String countries = "/countries";
  static String profile = "/profile";
  static String trip = "/trip";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("Route was not found");
      return;
    });

    router.define(trip, handler: tripHandler);
  }
}
