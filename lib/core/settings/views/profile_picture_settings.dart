part of core.settings;

class ProfilePictureSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final ThemeMode themeMode = state.settings.themeMode;

        return Scaffold(
          appBar: AppBar(
            title: Text('Profilbild ändern'),
          ),
        );
      },
    );
  }
}
