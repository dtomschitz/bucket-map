part of blocs.profile;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    @required AuthenticationRepository authenticationRepository,
    @required ProfileRepository profileRepository,
  })  : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
        super(ProfileUninitialized()) {
    _subscription = _authenticationRepository.user.listen((user) {
      add(LoadProfile(user.id));
    });
  }

  final AuthenticationRepository _authenticationRepository;
  final ProfileRepository _profileRepository;

  StreamSubscription _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfile) {
      yield* _mapLoadProfileToState(event);
    } else if (event is UnlockCountry) {
      yield* _mapUnlockCountryToProfile(event);
    }
  }

  Stream<ProfileState> _mapLoadProfileToState(LoadProfile event) async* {
    yield ProfileLoading();

    var profile = await _profileRepository.getProfile(event.id);
    var countries = await _loadCountries(profile.unlockedCountries);

    yield ProfileLoaded(profile: profile, countries: countries);
  }

  Stream<ProfileState> _mapUnlockCountryToProfile(UnlockCountry event) async* {
    if (state is ProfileLoaded) {
      var profile = (state as ProfileLoaded).profile;
      var countries = (state as ProfileLoaded).countries;

      var unlockedCountries = [
        ...profile.unlockedCountries,
        event.code,
      ].toList();

      profile = profile.copyWith(unlockedCountries: unlockedCountries);
      countries = [
        ...countries.map(
          (country) => country.copyWith(
            unlocked: unlockedCountries.contains(country.code),
          ),
        )
      ];

      await _profileRepository.updateProfile(profile);

      yield ProfileLoaded(
        profile: profile,
        countries: countries,
      );
    }
  }

  Future<List<Country>> _loadCountries(List<String> unlockedCountries) async {
    List<dynamic> json = jsonDecode(await _loadCountriesAssets());
    var countries = json.map((country) => Country.fromJson(country)).toList();

    countries = countries.map((country) {
      bool unlocked = unlockedCountries.contains(country.code);
      return country.copyWith(unlocked: unlocked);
    }).toList();

    return countries;
  }

  Future<String> _loadCountriesAssets() {
    return rootBundle.loadString('assets/countries.json');
  }
}
