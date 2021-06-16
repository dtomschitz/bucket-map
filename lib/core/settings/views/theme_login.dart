import 'package:bucket_map/core/app/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeLoginView extends StatefulWidget {
  @override
  _ThemeLoginViewState createState() => _ThemeLoginViewState();
}

class _ThemeLoginViewState extends State<ThemeLoginView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text('test'),
        onPressed: () {
          BlocProvider.of<AppBloc>(context)
              .add(UserPasswordChanged("neue Password"));
        },
      ),
    );
  }
}
