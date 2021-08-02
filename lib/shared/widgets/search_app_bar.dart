part of shared.widgets;

class SearchAppBar extends StatelessWidget with PreferredSizeWidget {
  SearchAppBar({this.child, this.leading});

  final Widget child;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: leading,
      title: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SearchBarContainer(child: child),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SearchBarContainer extends StatelessWidget {
  SearchBarContainer({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                height: 46,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
