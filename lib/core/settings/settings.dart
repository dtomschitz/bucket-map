library core.settings;

import 'dart:ui';

import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/shared/shared.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sections/app_settings.dart';
part 'sections/profile_settings.dart';

part 'views/homeland_settings.dart';
part 'views/profile_name_settings.dart';
part 'views/profile_picture_settings.dart';
part 'views/theme_settings.dart';

showSettingsView(BuildContext context, {Widget view}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => view,
      fullscreenDialog: true,
    ),
  );
}

class SettingsScreen extends StatelessWidget {
  static show(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Einstellungen'),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                ProfileSettingsSection(
                  onProfilePicture: () => _openSettingsSection(
                    context,
                    ProfilePictureSettingsView(),
                  ),
                  onProfileName: () => _openSettingsSection(
                    context,
                    ProfileNameSettingsView(),
                  ),
                ),
                AppSettingsSection(
                  onThemeMode: () => _openSettingsSection(
                    context,
                    ThemeSettingsView(),
                  ),
                ),
                _buildLogOutButton(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildLogOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        child: Text('Abmelden'),
        onPressed: () {
          BlocProvider.of<AppBloc>(context).add(LogoutRequested());
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }

  _openSettingsSection(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => screen),
    );
  }
}
