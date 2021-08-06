part of widgets;

class SlidingSheetDragger extends StatelessWidget {
  const SlidingSheetDragger({
    this.padding = const EdgeInsets.only(top: 8, bottom: 8),
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Container(
            width: 36,
            height: 4,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
