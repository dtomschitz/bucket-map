part of shared.models;

@immutable
class Profile {
  const Profile({
    String id,
    this.email,
    this.firstName,
    this.lastName,
    this.country,
    this.unlockedCountries,
  }) : this.id = id;

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String country;
  final List<UnlockedCountry> unlockedCountries;

  Profile copyWith({
    String id,
    String email,
    String firstName,
    String lastName,
    String country,
    List<UnlockedCountry> unlockedCountries,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      country: country ?? this.country,
      unlockedCountries: unlockedCountries ?? this.unlockedCountries,
    );
  }

  bool isCountryUnlocked(String code) {
    return unlockedCountries.contains((unlocked) => unlocked.code == code);
  }

  List<String> get unlockedCountryCodes {
    return unlockedCountries.map((country) => country.code).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      country.hashCode ^
      unlockedCountries.hashCode;

  @override
  String toString() {
    return 'Profile { id: $id, email: $email, firstName: $firstName, lastName: $lastName, country: $country }';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "country": country,
      "unlockedCountries":
          unlockedCountries.map((country) => country.toJson()).toList()
    };
  }

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"] as String,
      email: json["email"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      country: json["country"] as String,
      unlockedCountries: List.from(json["unlockedCountries"])
          .map((json) => UnlockedCountry.fromJson(json))
          .toList(),
    );
  }
}
