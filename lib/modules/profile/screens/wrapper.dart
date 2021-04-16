import 'package:bucket_map/modules/profile/models/user.dart';
import 'package:bucket_map/modules/profile/screens/authenticate/authenticate.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUserObject>(context);

    //return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return CountriesScreen();
    }
  }
}
