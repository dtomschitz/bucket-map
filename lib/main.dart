import 'package:bucket_map/blocs/bloc_observer.dart';
import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:bucket_map/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:permissions_plugin/permissions_plugin.dart' as perm_plug;

void main() async {
  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  PermissionStatus permission =
      await LocationPermissions().requestPermissions();

  Map<perm_plug.Permission, perm_plug.PermissionState> permission_2 =
      await perm_plug.PermissionsPlugin.requestPermissions(
          [perm_plug.Permission.READ_PHONE_STATE]);

  runApp(
    BlocProvider(
      create: (context) {
        return CountriesBloc()..add(LoadCountriesEvent());
      },
      child: App(),
    ),
  );
}
