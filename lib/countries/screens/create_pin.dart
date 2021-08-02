part of countries.screens;

class CreatePinScreen extends StatefulWidget {
  //CreatePinScreen(this.coordinates);
  //final LatLng coordinates;

  static show(BuildContext context, LatLng coordinates) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) => CreatePinScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  bool _firstPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pin erstellen'),
      ),
      body: PageTransitionSwitcher(
          reverse: !_firstPage,
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
            );
          },
          child: _firstPage
              ? CountriesMap(
                  key: UniqueKey(),
                )
              : Container(
                  key: UniqueKey(),
                )),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.arrow_forward_outlined),
        label: Text('Weiter'),
        onPressed: () {
          setState(() {
            _firstPage = !_firstPage;
          });
        },
      ),
    );
  }
}
