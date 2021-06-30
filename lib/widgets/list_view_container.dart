import 'package:flutter/material.dart';

class ListViewContainer extends StatelessWidget {
  ListViewContainer({this.title, this.subtitle, this.children});

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      physics: ClampingScrollPhysics(),
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline4,
        ),
        subtitle != null ? Text(subtitle) : Container(),
        SizedBox(height: 32),
        ...children
      ],
    );
  }
}
