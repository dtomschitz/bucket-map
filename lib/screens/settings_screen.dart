import 'package:bucket_map/blocs/settings/bloc.dart';
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
                  [
                    SettingsSection(
                      header: SettingsHeader('App Einstellungen'),
                      tiles: [
                        SettingsTile(
                          title: 'Erscheinungsbild',
                          subtitle: 'Test',
                          onTap: () => openSettingsSection(
                              context, ThemeSettingsScreen()),
                        ),
                      ],
                    )
                  ],
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
}

class ThemeSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: ListView(
        children: [
          SettingsSection(
            header: SettingsHeader('App Einstellungen'),
            tiles: [
              SettingsTile(
                title: 'Erscheinungsbild',
                subtitle: 'Test',
                onTap: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
