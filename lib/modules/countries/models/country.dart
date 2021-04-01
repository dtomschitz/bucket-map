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
];
