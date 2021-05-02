import 'package:bucket_map/core/app/app.dart';
import 'package:bucket_map/core/auth/repositories/repositories.dart';
import 'package:bucket_map/core/bloc_observer.dart';
import 'package:bucket_map/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  final sharedPrefs = await SharedPreferencesService.instance;
  await sharedPrefs.loadSettings();

  runApp(App(authenticationRepository: authenticationRepository));
}
