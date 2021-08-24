part of core.settings;

class AppSettingsSection extends StatelessWidget {
  AppSettingsSection({this.onThemeMode});

  final VoidCallback onThemeMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (oldState, state) {
        return oldState.settings.themeMode != state.settings.themeMode;
      },
      builder: (context, state) {
        final ThemeMode themeMode = state.settings.themeMode;

        return SettingsSection(
          header: SettingsHeader('App Einstellungen'),
          tiles: [
            SettingsTile(
              title: 'Erscheinungsbild',
              subtitle: themeMode == ThemeMode.system
                  ? 'System'
                  : themeMode == ThemeMode.dark
                      ? 'Dunkel'
                      : 'Hell',
              onTap: () => showSettingsView(
                context,
                view: ThemeSettingsView(),
              ),
            ),
          ],
        );
      },
    );
  }
}
