import 'package:flutter/material.dart';

class Country {
  final String name;
  final String code;
  bool unlocked;

  Country({
    @required this.name,
    @required this.code,
    @required this.unlocked,
  });
}

final List<Country> countries = <Country>[
  Country(name: 'Deutschland', code: 'de', unlocked: false),
  Country(name: 'Frankreich', code: 'fr', unlocked: false),
  Country(name: 'United States', code: 'us', unlocked: false),
  Country(name: 'Italien', code: 'it', unlocked: false),
  Country(name: 'Afghanistan', code: 'af', unlocked: false),
  Country(name: 'Antarctica', code: 'aq', unlocked: false),
  Country(name: 'Bhutan', code: 'bt', unlocked: false),
  Country(name: 'Brazil', code: 'br', unlocked: false),
  Country(name: 'Chile', code: 'cl', unlocked: false),
  Country(name: 'Cuba', code: 'cu', unlocked: false),
  Country(name: 'Croatia', code: 'hr', unlocked: false),
  Country(name: 'Denmark', code: 'dk', unlocked: false),
  Country(name: 'Finland', code: 'fi', unlocked: false),
  Country(name: 'Ghana', code: 'gh', unlocked: false),
  Country(name: 'Heard Island and McDonald Islands', code: 'hm', unlocked: false),
  Country(name: 'Mexico', code: 'mx', unlocked: false),
  Country(name: 'Pakistan', code: 'pk', unlocked: false),
  Country(name: 'United Kingdom', code: 'gb', unlocked: false),
  Country(name: 'Vatican City (Holy See)', code: 'va', unlocked: false),

];
