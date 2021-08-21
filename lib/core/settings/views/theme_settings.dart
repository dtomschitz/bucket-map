part of core.settings;

class ThemeSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final ThemeMode themeMode = state.settings.themeMode;

        return Scaffold(
          appBar: AppBar(
            title: Text('Erscheinungsbild'),
          ),
          body: Column(
            children: [
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
                currentThemeMode: themeMode,
                themeMode: ThemeMode.dark,
              ),
              _buildOption(
                context: context,
                title: 'Hell',
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
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          themeMode == currentThemeMode ? Icon(Icons.check_outlined) : null,
      onTap: () {
        BlocProvider.of<SettingsBloc>(context).add(
          SettingsChanged(changes: Settings(themeMode: themeMode)),
        );
      },
      dense: true,
    );
  }
}
