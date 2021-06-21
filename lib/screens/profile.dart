import 'package:bucket_map/blocs/profile/bloc.dart';
import 'package:bucket_map/core/app/bloc/bloc.dart';
import 'package:bucket_map/core/settings/settings_screen.dart';
import 'package:bucket_map/models/user.dart';
import 'package:bucket_map/screens/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:bucket_map/core/auth/repositories/auth_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //final User user;
  //_ProfileScreenState({this.user});

  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

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
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    imageProfile(),
                    SizedBox(height: 25.0),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.normal),
                      ),
                      onPressed: () => _showNamePanel(),
                      child: Text(state.profile.firstName),
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
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Buckets',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '24',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Besucht',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '250',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Pins',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
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
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: _imageFile == null
                  ? AssetImage("assets/default_profile_picture.png")
                  : FileImage(File(_imageFile.path)),
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ]
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        Text(
          "Choose Profile Photo",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ],
        )
      ]
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
        source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

}
