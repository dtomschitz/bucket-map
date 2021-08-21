part of screens;

class ProfileScreen extends StatelessWidget {
  static show(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ProfileScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              SettingsScreen.show(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return Column(
              children: [
                SizedBox(height: 32),
                _ProfileAvatar(
                  firstName: state.profile.firstName,
                  lastName: state.profile.lastName,
                  photo: state.user?.photo,
                ),
                SizedBox(height: 32),
                _ProfileStatistics(),
              ],
            );
          }

          return TopCircularProgressIndicator();
        },
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  _ProfileAvatar({
    this.firstName,
    this.lastName,
    this.photo,
  });

  final String firstName;
  final String lastName;
  final String photo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          maxRadius: 72,
          child: photo == null ? Text('DT') : null,
          backgroundColor: Colors.black.withOpacity(.10),
          backgroundImage: photo != null ? NetworkImage(photo) : null,
        ),
        SizedBox(height: 16),
        Text(
          '$firstName $lastName',
          style: Theme.of(context).textTheme.headline4,
        )
      ],
    );
  }
}

class _ProfileStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(width: 8),
        BlocBuilder<PinsBloc, PinsState>(
          builder: (context, state) {
            if (state is PinsLoaded) {
              return _ProfileStatistic(
                count: state.pins.length,
                text: 'Erstellte Pins',
              );
            }

            return Spacer();
          },
        ),
        SizedBox(width: 8),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return _ProfileStatistic(
                count: state.profile.unlockedCountries.length,
                text: 'Freigeschaltene Länder',
              );
            }

            return Spacer();
          },
        ),
        SizedBox(width: 8),
        _ProfileStatistic(
          count: 4,
          text: 'Geplante Reisen',
        ),
        SizedBox(width: 8),
      ],
    );
  }
}

class _ProfileStatistic extends StatelessWidget {
  _ProfileStatistic({this.count, this.text});

  final int count;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
