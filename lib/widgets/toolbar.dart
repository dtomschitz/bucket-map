
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Toolbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State createState() => new _ToolbarState();

  @override
  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }
}

class _ToolbarState extends State<Toolbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: Icon(Icons.search), onPressed: () => {}),
      centerTitle: true,
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () => {}),
        IconButton(icon: Icon(Icons.settings), onPressed: () => {})
      ],
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }
}
