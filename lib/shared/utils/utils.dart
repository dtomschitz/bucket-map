library shared.utils;

import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:bucket_map/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'geo.dart';
part 'interval.dart';
part 'shared_preferences_service.dart';

class Utils {
  static String formatDate(DateTime date, {String format = 'dd.MM.yyyy'}) {
    return new DateFormat(format).format(date);
  }
}
