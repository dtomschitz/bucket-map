part of shared.models;

class User extends Equatable {
  const User({
    this.email,
    this.password,
    @required this.id,
    this.name,
    this.photo,
    this.currentCountry,
    this.countries,
  });

  final String id;
  final String email;
  final String password;
  final String name;
  final String photo;
  final String currentCountry;
  final List<String> countries;

  static const anonymous = User(id: '');

  bool get isAnonymous => this == User.anonymous;
  bool get isNotAnonymous => this != User.anonymous;

  @override
  List<Object> get props => [
        email,
        password,
        id,
        name,
        photo,
        currentCountry,
        countries,
      ];
}
