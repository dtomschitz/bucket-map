part of blocs.profile;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    @required AuthenticationRepository authenticationRepository,
    @required ProfileRepository profileRepository,
  })  : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
        super(ProfileUninitialized()) {
    _subscription = _authenticationRepository.user.listen((user) {
      add(LoadProfile(user));
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
    var profile = await _profileRepository.getProfile(event.user.id);
    yield ProfileLoaded(profile: profile, user: event.user);
  }

  Stream<ProfileState> _mapUnlockCountryToProfile(UnlockCountry event) async* {
    if (state is ProfileLoaded) {
      var profile = (state as ProfileLoaded).profile;
      if (profile.unlockedCountries.contains(event.code)) {
        return;
      }

      var unlockedCountries = [
        ...profile.unlockedCountries,
        event.code,
      ].toList();

      profile = profile.copyWith(unlockedCountries: unlockedCountries);
      await _profileRepository.updateProfile(profile);

      yield ProfileLoaded(
        profile: profile,
        user: (state as ProfileLoaded).user,
      );
    }
  }
}
