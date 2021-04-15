import 'package:bucket_map/blocs/settings/bloc.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  [_buildThemeSettingsSection(context, state)],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  openSettingsSection(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => screen),
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
          onTap: () => openSettingsSection(context, ThemeSettingsScreen()),
        ),
      ],
    );
  }
}

class ThemeSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final ThemeMode themeMode = state.settings.themeMode;

        return Scaffold(
          appBar: AppBar(
            title: Text(''),
          ),
          body: ListView(
            children: [
              SettingsHeader('App Einstellungen'),
              _buildOption(
                context: context,
                title: 'System',
                subtitle: 'Wählt das Erscheinungsbild des Systems aus',
                currentThemeMode: themeMode,
                themeMode: ThemeMode.system,
              ),
              _buildOption(
                context: context,
                title: 'Dunkel',
                subtitle: 'Wählt das Erscheinungsbild des Systems aus',
                currentThemeMode: themeMode,
                themeMode: ThemeMode.dark,
              ),
              _buildOption(
                context: context,
                title: 'Hell',
                subtitle: 'Wählt das Erscheinungsbild des Systems aus',
                currentThemeMode: themeMode,
                themeMode: ThemeMode.light,
              ),
            ],
          ),
        );
      },
    );
  }

  _buildOption({
    BuildContext context,
    String title,
    String subtitle,
    ThemeMode currentThemeMode,
    ThemeMode themeMode,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing:
          themeMode == currentThemeMode ? Icon(Icons.check_outlined) : null,
      onTap: () {
        BlocProvider.of<SettingsBloc>(context).add(
          SettingsChanged(changes: Settings(themeMode: themeMode)),
        );
      },
    );
  }
}
