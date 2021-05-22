import 'package:flutter/material.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  String _currentName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        Text(
          'Hier kannst du deinen Namen eingeben.',
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 20.0),
        TextFormField(
          validator: (val) => val.isEmpty ? 'Gib einen Namen ein' : null,
          onChanged: (val) => setState(() => _currentName = val),
        ),
        SizedBox(height: 20.0),
        RaisedButton(
          child: Text(
            'Namen ändern',
          ),
          onPressed: () async {
            print(_currentName);
          },
        ),
      ]),
    );
  }
}
