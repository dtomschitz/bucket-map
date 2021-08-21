part of core.settings;

class ProfileSettingsSection extends StatelessWidget {
  ProfileSettingsSection({
    this.onProfilePicture,
    this.onProfileName,
    this.onCountry,
  });

  final VoidCallback onProfilePicture;
  final VoidCallback onProfileName;
  final VoidCallback onCountry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          final profile = profileState.profile;

          return SettingsSection(
            header: SettingsHeader('Profil Einstellungen'),
            tiles: [
              SettingsTile(
                title: 'Profilbild ändern',
                onTap: () => showSettingsView(
                  context,
                  view: ProfilePictureSettingsView(),
                ),
              ),
              SettingsTile(
                title: 'Name',
                subtitle: '${profile.firstName} ${profile.lastName}',
                onTap: () => showSettingsView(
                  context,
                  view: ProfileNameSettingsView(
                    profile: profile,
                  ),
                ),
              ),
              BlocBuilder<CountriesBloc, CountriesState>(
                builder: (context, countriesState) {
                  if (countriesState is CountriesLoaded) {
                    final country = countriesState.countries.firstWhere(
                      (country) => country.code == profile.country,
                    );
                    return SettingsTile(
                      title: 'Heimatland bearbeiten',
                      subtitle: country.name,
                      onTap: onCountry?.call,
                    );
                  }
                  return Container();
                },
              )
            ],
          );
        }

        return Container();
      },
    );
  }
}
