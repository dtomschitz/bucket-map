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
  final List<String> unlockedCountries;

  Profile copyWith({
    String id,
    String email,
    String firstName,
    String lastName,
    String country,
    List<String> unlockedCountries,
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
      "unlockedCountries": unlockedCountries
    };
  }

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"] as String,
      email: json["email"] as String,
      firstName: json["firstName"] as String,
      lastName: json["lastName"] as String,
      country: json["country"] as String,
      unlockedCountries: new List<String>.from(json["unlockedCountries"]),
    );
  }
}
