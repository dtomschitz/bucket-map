import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/core/core.dart';
import 'package:bucket_map/shared/shared.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final profileRepository = ProfileRepository();
  final pinsRepository = PinsRepository();
  final authenticationRepository = AuthRepository(
    profileRepository: profileRepository,
  );

  await authenticationRepository.user.first;

  final sharedPreferencesService = await SharedPreferencesService.instance;
  await sharedPreferencesService.loadSettings();

  Settings initialSettings = sharedPreferencesService.settings != null
      ? Settings.fromJson(sharedPreferencesService.settings)
      : Settings();

  runApp(
    App(
      authenticationRepository: authenticationRepository,
      profileRepository: profileRepository,
      pinsRepository: pinsRepository,
      sharedPreferencesService: sharedPreferencesService,
      initialSettings: initialSettings,
    ),
  );
}
