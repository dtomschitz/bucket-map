part of screens;

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

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
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final isProfileLoaded = state is ProfileLoaded;
          final content = isProfileLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //ProfileImage(),
                    /*CircleAvatar(
                              backgroundColor: Colors.brown.shade800,
                              backgroundImage: NetworkImage(state.user?.photo),
                            ),*/
                    SizedBox(height: 25.0),
                    Text(
                      '',
                      //'${state.profile.firstName} ${state.profile.lastName}',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'aktuell in Deutschland',
                    ),
                    Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '100',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Besucht',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '250',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Pins',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : TopCircularProgressIndicator();

          return CustomScrollView(
            physics: !isProfileLoaded ? NeverScrollableScrollPhysics() : null,
            slivers: [
              SliverAppBar(
                title: Text('Profil'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings_outlined),
                    onPressed: () {
                      SettingsScreen.show(context);
                    },
                  ),
                ],
                pinned: true,
              ),
              SliverList(delegate: SliverChildListDelegate.fixed([content])),
            ],
          );
        },
      ),
    );
  }
}
