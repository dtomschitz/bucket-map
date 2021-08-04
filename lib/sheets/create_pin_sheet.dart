part of sheets;

class CreatePinSheet extends StatefulWidget {
  @override
  State createState() => _CreatePinSheetState();
}

class _CreatePinSheetState extends State<CreatePinSheet> {
  final SheetController controller = SheetController();
  StreamSubscription _subscription;

  static const visibleSnap = 0.4;

  @override
  initState() {
    super.initState();

    _subscription = EventProvider.of(context).events.listen((event) {
      if (event is ShowCreatePinSheet) {
        controller.snapToExtent(visibleSnap);
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
      controller: controller,
      addTopViewPaddingOnFullscreen: true,
      cornerRadius: 16,
      cornerRadiusOnFullscreen: 0,
      backdropColor: Colors.transparent,
      snapSpec: SnapSpec(
        snap: true,
        positioning: SnapPositioning.relativeToAvailableSpace,
        snappings: const [
          0.0,
          SnapSpec.headerSnap,
          visibleSnap,
          SnapSpec.expanded
        ],
        initialSnap: 0.0,
      ),
      headerBuilder: _buildHeader,
      builder: _buildPanel,
    );
  }

  Widget _buildHeader(BuildContext context, SheetState state) {
    return SheetListenerBuilder(
      builder: (context, state) {
        return Material(
          color: Colors.white,
          elevation: !state.isAtTop ? 8.0 : 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SlidingSheetDragger(
                padding: EdgeInsets.only(top: 8, bottom: 8),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Neuen Pin erstellen',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Erstelle einen neuen Pin in diesem Land',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPanel(BuildContext context, SheetState state) {
    final height = MediaQuery.of(context).size.height - kToolbarHeight;
    return Container(
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTap: () {
                controller.snapToExtent(SnapSpec.expanded);
              },
            ),
          ),
          CountrySelect(),
          //Spacer(),
        ],
      ),
    );
  }
}
