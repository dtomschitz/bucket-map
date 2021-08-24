part of widgets;

class TopCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 32),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
