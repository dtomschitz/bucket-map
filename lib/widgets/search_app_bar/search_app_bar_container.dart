part of widgets;

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
              elevation: 0,
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
