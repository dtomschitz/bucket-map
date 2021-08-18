library shared.utils;

import 'dart:convert';
import 'package:bucket_map/core/auth/auth.dart';
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

const Pattern emailPattern =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?)*$";

class Utils {
  static String formatDate(DateTime date, {String format = 'dd.MM.yyyy'}) {
    return new DateFormat(format).format(date);
  }

  static String validateEmail(String value) {
    RegExp regex = new RegExp(emailPattern);

    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Bitte geben Sie eine korrekt E-Mail ein';
    }

    return null;
  }

  static String validateString(String value, {String message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Bitte geben Sie einen Wert ein';
    }

    return null;
  }

  static String validatePassword(String value) {
    if (value == null || value.isEmpty) {
      return 'Bitte geben Sie ihr Passwort ein';
    }

    return null;
  }
}
