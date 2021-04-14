import 'package:bucket_map/blocs/bloc_observer.dart';
import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/blocs/theme/bloc.dart';
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
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(LoadTheme()),
        ),
        BlocProvider<CountriesBloc>(
          create: (context) => CountriesBloc()..add(LoadCountriesEvent()),
        )
      ],
      child: App(),
    ),
  );
}
