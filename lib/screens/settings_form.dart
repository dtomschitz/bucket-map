import 'package:bucket_map/core/auth/repositories/auth_repository.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:bucket_map/models/user.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  String _currentName;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: AuthenticationRepository().userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Text(
                  'Hier kannst du deinen Namen eingeben.',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData.name,
                  validator: (val) =>
                      val.isEmpty ? 'Gib einen Namen ein' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  child: Text(
                    'Namen ändern',
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await AuthenticationRepository()
                          .updateUserData(
                        _currentName ?? userData.name,
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ]),
            );
          } else {
            return LoadingSpinner();
          }
        });
  }
}
