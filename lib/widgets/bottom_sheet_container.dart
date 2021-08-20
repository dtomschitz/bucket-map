part of widgets;

class BottomSheetContainer extends StatelessWidget {
  BottomSheetContainer({
    this.title,
    this.leading,
    List<Widget> children,
    MainAxisSize mainAxisSize,
  })  : children = children ?? [],
        mainAxisSize = mainAxisSize ?? MainAxisSize.min;

  final Widget leading;
  final String title;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: mainAxisSize,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                leading != null
                    ? Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: leading,
                      )
                    : Container(),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close_outlined),
                  //padding: EdgeInsets.all(16),
                  splashRadius: 22,
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
