import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/core/app/app.dart';
import 'package:bucket_map/core/auth/repositories/repositories.dart';
import 'package:bucket_map/core/bloc_observer.dart';
import 'package:bucket_map/core/settings/models/models.dart';
import 'package:bucket_map/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final profileRepository = ProfileRepository();
  final pinRepository = PinRepository();

  final authenticationRepository = AuthenticationRepository(
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
      pinRepository: pinRepository,
      sharedPreferencesService: sharedPreferencesService,
      initialSettings: initialSettings,
    ),
  );
}
