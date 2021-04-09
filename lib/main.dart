import 'package:bucket_map/blocs/bloc_observer.dart';
import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:bucket_map/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  runApp(
    BlocProvider(
      create: (context) {
        return CountriesBloc()..add(LoadCountriesEvent());
      },
      child: App(),
    ),
  );
}
