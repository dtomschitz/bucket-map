part of blocs.profile;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    @required AuthRepository authenticationRepository,
    @required ProfileRepository profileRepository,
  })  : _authenticationRepository = authenticationRepository,
        _profileRepository = profileRepository,
        super(ProfileUninitialized()) {
    _authSubscription = _authenticationRepository.user.listen((user) {
      add(LoadProfile(user));
    });
  }

  final AuthRepository _authenticationRepository;
  final ProfileRepository _profileRepository;

  StreamSubscription _authSubscription;
  StreamSubscription _profileSubscription;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _profileSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfile) {
      yield* _mapLoadProfileToState(event);
    } else if (event is UpdateProfile) {
      yield* _mapUpdateProfileToState(event);
    } else if (event is UnlockCountry) {
      yield* _mapUnlockCountryToProfile(event);
    } else if (event is ProfileUpdated) {
      yield* _mapProfileUpdatedToState(event);
    }
  }

  Stream<ProfileState> _mapLoadProfileToState(LoadProfile event) async* {
    yield ProfileLoading();

    _profileSubscription?.cancel();
    _profileSubscription = _profileRepository.getProfile(event.user.id).listen(
      (profile) {
        print('test' + profile.firstName);
        add(ProfileUpdated(profile: profile, user: event.user));
      },
    );
  }

  Stream<ProfileState> _mapUpdateProfileToState(UpdateProfile event) async* {
    _profileRepository.updateProfile(event.profile);
  }

  Stream<ProfileState> _mapUnlockCountryToProfile(UnlockCountry event) async* {
    if (state is ProfileLoaded) {
      var profile = (state as ProfileLoaded).profile;
      if (profile.unlockedCountryCodes.contains(event.code)) {
        return;
      }

      var unlockedCountries = [
        ...profile.unlockedCountries,
        UnlockedCountry.now(event.code),
      ].toList();

      profile = profile.copyWith(unlockedCountries: unlockedCountries);
      await _profileRepository.updateProfile(profile);

      yield ProfileLoaded(
        profile: profile,
        user: (state as ProfileLoaded).user,
      );
    }
  }

  Stream<ProfileState> _mapProfileUpdatedToState(ProfileUpdated event) async* {
    yield ProfileLoaded(profile: event.profile, user: event.user);
  }
}
