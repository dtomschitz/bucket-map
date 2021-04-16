import 'package:bucket_map/modules/profile/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:bucket_map/modules/profile/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: Text(
          'Profil',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign in'),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              validator: (val) => val.isEmpty ? 'Enter an email.' : null,
              onChanged: (val) {
              setState(() => email = val);
            }),
            SizedBox(height: 20.0),
            TextFormField(
              obscureText: true,
              validator: (val) => val.length < 6 ? 'Your password must be at least 6 characters long.' : null,
                onChanged: (val) {
                  setState(() => password = val);
                }),
            SizedBox(height: 20.0),
            RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    print(email);
                    print(password);
                  }
                }),
          ]),
        ),
        /*child: RaisedButton(
            child: Text('Sign in anonymously'),
            onPressed: () async {
              dynamic result = await _auth.signInAnonym();
              if (result == null) {
                print('error signing in');
              } else {
                print('signed in');
                print(result.uid);
              }
            }),*/
      ),
    );
  }
}
