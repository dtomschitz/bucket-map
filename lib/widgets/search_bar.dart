import 'package:flutter/material.dart';

enum SearchBarState { elevated, bordered }

class SearchBar extends StatelessWidget with PreferredSizeWidget {
  final Widget child;
  final double height;
  final SearchBarState state;

  SearchBar({
    @required this.child,
    this.state = SearchBarState.elevated,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 4,
        child: Container(
          height: 46,
          width: double.infinity,
          padding: EdgeInsets.only(right: 16, left: 16),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.search_outlined),
              ),
              Text('Search')
            ],
          ),
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
