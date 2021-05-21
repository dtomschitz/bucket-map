import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// User model
///
/// [User.anonymous] represents an unauthenticated user.
class User extends Equatable {
  /// {@macro user}
  const User({
    this.email,
    this.password,
    @required this.id,
    this.name,
    this.photo,
    this.planned,
    this.amountCountries,
    this.amountPins,
    this.currentCountry,
    this.countries,
    this.pinIds,
  });

  /// The current user's email address.
  final String email;

  ///The current user's password.
  final String password;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  /// Url for the current user's photo.
  final String photo;

  ///The current amount of countries the user want to visit.
  final int planned;

  ///The current amount of countires the user had visited.
  final int amountCountries;

  ///The current amount of pins the user had created.
  final int amountPins;

  ///The country in which the user is currently located.
  final String currentCountry;

  ///List with created Pins
  final List<String> countries;

  ///List with Pin Id's
  final List<int> pinIds;

  /// Anonymous user which represents an unauthenticated user.
  static const anonymous = User(id: '');

  /// Convenience getter to determine whether the current user is anonymous.
  bool get isAnonymous => this == User.anonymous;

  /// Convenience getter to determine whether the current user is not anonymous.
  bool get isNotAnonymous => this != User.anonymous;

  @override
  List<Object> get props => [
        email,
        password,
        id,
        name,
        photo,
        planned,
        amountCountries,
        amountPins,
        currentCountry,
        countries,
        pinIds,
      ];
}
