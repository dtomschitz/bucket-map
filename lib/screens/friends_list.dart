import 'package:bucket_map/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bucket_map/core/auth/repositories/auth_repository.dart';
import 'package:bucket_map/screens/profile.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final User user;
  _FriendListState({this.user});

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<User>>(context);
    final currentUser = users[0];

    users.forEach((user) {
      print(user.id);
      print(user.name);
      print(user.photo);
      print(user.amountCountries);
      print(user.amountPins);
      print(user.currentCountry);
    });

    return ListView(children: <Widget>[
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
          Text(
            '${currentUser.name}',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Text(
            'aktuell in ${currentUser.currentCountry}',
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
                      '${currentUser.planned}',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'BUCKETS',
                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${currentUser.amountCountries}',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'BESUCHT',
                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${currentUser.amountPins}',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'PINS',
                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
