import 'package:bucket_map/blocs/bloc_observer.dart';
import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/blocs/settings/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:bucket_map/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc()..add(LoadSettings()),
        ),
        BlocProvider<CountriesBloc>(
          create: (context) => CountriesBloc()..add(LoadCountriesEvent()),
        )
      ],
      child: App(),
    ),
  );
}
