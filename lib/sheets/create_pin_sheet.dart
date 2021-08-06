part of sheets;

class CreatePinSheet extends StatefulWidget {
  CreatePinSheet({this.child, this.animationController});

  final Widget child;
  final AnimationController animationController;

  @override
  State createState() => _CreatePinSheetState();
}

class _CreatePinSheetState extends State<CreatePinSheet>
    with TickerProviderStateMixin {
  final SheetController _sheetController = SheetController();

  final _focusNode = new FocusNode();
  final _formKey = GlobalKey<FormState>();

  AnimationController _controller;
  Animation<double> _animation;

  StreamSubscription _subscription;
  LatLng _coordinates;

  bool _showCloseButton = false;

  static const visibleSnap = 0.35;

  static const duration = Duration(milliseconds: 500);
  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );

    _subscription = EventProvider.of(context).events.listen((event) {
      if (event is ShowCreatePinSheet) {
        _sheetController.snapToExtent(
          visibleSnap,
          duration: duration,
        );
        setState(() => _coordinates = event.coordinates);
      }
    });
  }

  @override
  dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingSheet(
      controller: _sheetController,
      addTopViewPaddingOnFullscreen: true,
      cornerRadius: 16,
      cornerRadiusOnFullscreen: 0,
      duration: const Duration(milliseconds: 850),
      snapSpec: SnapSpec(
        snap: true,
        positioning: SnapPositioning.relativeToAvailableSpace,
        initialSnap: 0.0,
        snappings: const [
          0.0,
          SnapSpec.headerSnap,
          visibleSnap,
          SnapSpec.expanded
        ],
      ),
      listener: (state) {
        if (state.extent > 0.6 && !_controller.isAnimating) {
          _controller.forward();
        }

        if (state.extent < 0.6 && !_controller.isAnimating) {
          _controller.reverse();
        }

        if (state.extent == 0) {
          setState(() => _coordinates = null);
          dispatchEvent(context, HideCreatePinSheet());
        }
      },
      body: widget.child,
      headerBuilder: _buildHeader,
      builder: _buildPanel,
    );
  }

  Widget _buildHeader(BuildContext context, SheetState state) {
    final height = MediaQuery.of(context).padding.top;

    return SheetListenerBuilder(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            _sheetController.snapToExtent(
              visibleSnap,
              duration: const Duration(milliseconds: 500),
            );
          },
          child: Container(
            height: height,
            child: Material(
              color: Colors.white,
              elevation: !state.isAtTop ? 8.0 : 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SlidingSheetDragger(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Neuen Pin erstellen',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Erstelle einen neuen Pin in diesem Land',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPanel(BuildContext context, SheetState state) {
    final height = MediaQuery.of(context).size.height - kToolbarHeight;

    return Material(
      color: Colors.white,
      child: Container(
        height: height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                //focusNode: _focusNode,
                onTap: () {
                  if (state.extent != SnapSpec.expanded) {
                    _sheetController.snapToExtent(
                      SnapSpec.expanded,
                      duration: const Duration(milliseconds: 500),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            ConditionalChild(
              condition: _coordinates != null,
              child: FadeTransition(
                opacity: _animation,
                child: Column(
                  children: [
                    CountrySelect(),
                    PinPreviewCard(
                      coordinates: _coordinates,
                      height: 346,
                      elevation: 0,
                      padding: EdgeInsets.all(16),
                    ),
                    ListTile(
                      leading: Icon(Icons.place_outlined),
                      title: Text('Aktuelle Position'),
                      subtitle: _coordinates != null
                          ? Text(
                              _coordinates.latitude.toString() +
                                  ' ' +
                                  _coordinates.longitude.toString(),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
