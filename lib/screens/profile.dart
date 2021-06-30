import 'package:bucket_map/core/app/bloc/bloc.dart';
import 'package:bucket_map/core/settings/settings_screen.dart';
import 'package:bucket_map/models/user.dart';
import 'package:bucket_map/screens/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:bucket_map/core/auth/repositories/auth_repository.dart';
import 'package:flutter/gestures.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //final User user;
  //_ProfileScreenState({this.user});

  @override
  Widget build(BuildContext context) {
    //final users = Provider.of<List<User>>(context);
    //final currentUser = users[0];

    void _showNamePanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset("assets/default_profile_picture.png"),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.normal),
                    ),
                    onPressed: () => _showNamePanel(),
                    child: Text('$SettingsForm._currentName'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'aktuell in Deutschland',
                  ),
                  Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '3',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Buckets',
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '24',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Besucht',
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '250',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Pins',
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
