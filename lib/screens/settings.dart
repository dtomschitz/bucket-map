part of screens;

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
        onPressed: () {
          Navigator.pop(context);
          context.read<AppBloc>().add(LogoutRequested());
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

class ThemeSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final ThemeMode themeMode = state.settings.themeMode;

        return Scaffold(
          appBar: AppBar(
            title: Text(''),
          ),
          body: Column(
            children: [
              SettingsHeader('Erscheinungsbild'),
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
