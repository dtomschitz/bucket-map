import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Country extends Equatable {
  //final String id;
  final String name;
  final String code;

  const Country({
    @required this.name,
    @required this.code,
  });

  /*Country.
  
  (Map<String, dynamic> json)
      : name = json['name'],
        code = json['code'];*/

  @override
  List<Object> get props => [name, code];

  @override
  String toString() => 'Country { code: $code }';
}

final List<Country> countries = <Country>[
  Country(name: 'Deutschland', code: 'de'),
  Country(name: 'Frankreich', code: 'fr'),
  Country(name: 'United States', code: 'us'),
  Country(name: 'Italien', code: 'it'),
  Country(name: 'Afghanistan', code: 'af'),
  Country(name: 'Antarctica', code: 'aq'),
  Country(name: 'Bhutan', code: 'bt'),
  Country(name: 'Brazil', code: 'br'),
  Country(name: 'Chile', code: 'cl'),
  Country(name: 'Cuba', code: 'cu'),
  Country(name: 'Croatia', code: 'hr'),
  Country(
    name: 'Denmark',
    code: 'dk',
  ),
  Country(name: 'Finland', code: 'fi'),
  Country(name: 'Ghana', code: 'gh'),
  Country(
    name: 'Heard Island and McDonald Islands',
    code: 'hm',
  ),
  Country(
    name: 'Mexico',
    code: 'mx',
  ),
  Country(
    name: 'Pakistan',
    code: 'pk',
  ),
  Country(
    name: 'United Kingdom',
    code: 'gb',
  ),
  Country(
    name: 'Vatican City (Holy See)',
    code: 'va',
  ),
];
