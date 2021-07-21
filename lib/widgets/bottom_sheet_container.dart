import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  BottomSheetContainer({this.title, List<Widget> children})
      : children = children ?? [];

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.place_outlined),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          ...children
              .map((child) => SizedBox(width: double.infinity, child: child))
              .toList(),
        ],
      ),
    );
  }
}
