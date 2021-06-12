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
    final profile = await _profileRepository.getProfile(event.id);
    yield ProfileLoaded(profile);
  }

  Stream<ProfileState> _mapUnlockCountryToProfile(UnlockCountry event) async* {
    if (state is ProfileLoaded) {
      final profile = (state as ProfileLoaded).profile;
      final countries = [...profile.unlockedCountries, event.code].toList();
      final updatedProfile = profile.copyWith(unlockedCountries: countries);

      await _profileRepository.updateProfile(updatedProfile);
      yield ProfileLoaded(updatedProfile);
    }
  }
}
