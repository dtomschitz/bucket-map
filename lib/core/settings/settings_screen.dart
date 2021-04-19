import 'package:bucket_map/core/app/bloc/bloc.dart';
import 'package:bucket_map/core/settings/bloc/bloc.dart';
import 'package:bucket_map/core/settings/views/views.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
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
                    _buildThemeSettingsSection(context, state),
                    _buildLogOutButton(context),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _buildThemeSettingsSection(BuildContext context, SettingsState state) {
    ThemeMode themeMode = state.settings.themeMode;
    String subtitle = themeMode == ThemeMode.system
        ? 'System'
        : themeMode == ThemeMode.dark
            ? 'Dunkel'
            : 'Hell';

    return SettingsSection(
      header: SettingsHeader('App Einstellungen'),
      tiles: [
        SettingsTile(
          title: 'Erscheinungsbild',
          subtitle: subtitle,
          onTap: () => _openSettingsSection(context, ThemeSettingsView()),
        ),
      ],
    );
  }

  _buildLogOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        child: Text('Abmelden'),
        onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
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
