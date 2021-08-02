part of countries.widgets;

class UnlockedCountriesSheet extends StatefulWidget {
  UnlockedCountriesSheet({
    this.body,
    this.controller,
    this.onHeaderTap,
    this.onCountryTap,
    this.onPanelSlide,
    this.onPanelClose,
    this.onPanelStartScroll,
    this.onPanelUpdateScroll,
    this.onPanelEndScroll,
  });

  final Widget body;
  final SlidingSheetController controller;

  final void Function() onHeaderTap;
  final void Function(double progress) onPanelSlide;
  final void Function() onPanelClose;
  final void Function(ScrollMetrics metrics) onPanelStartScroll;
  final void Function(ScrollMetrics metrics) onPanelUpdateScroll;
  final void Function(ScrollMetrics metrics) onPanelEndScroll;

  final void Function(Country) onCountryTap;

  @override
  State createState() => _UnlockedCountriesSheetState();
}

class _UnlockedCountriesSheetState extends State<UnlockedCountriesSheet> {
  final ScrollController _scrollController = new ScrollController();

  double _elevation = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight =
        MediaQuery.of(context).size.height + kBottomNavigationBarHeight;

    return SlidingSheet(
      controller: widget.controller,
      scrollController: _scrollController,
      maxHeight: maxHeight,
      minHeight: 0,
      backdropEnabled: true,
      //parallaxEnabled: true,
      backdropColor: Colors.black,
      onPanelClosed: () {
        _scrollController.jumpTo(0);
        widget.onPanelClose?.call();
      },
      onPanelSlide: widget.onPanelSlide?.call,
      body: widget.body,
      panelBuilder: _buildPanel,
      collapseBuilder: _buildHeader,
    );
  }

  Widget _buildHeader() {
    /*return GestureDetector(
      onTap: widget.onHeaderTap,
      child: Material(
        elevation: _elevation,
        child: FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                0.3,
                0.8,
                curve: Curves.ease,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SlidingSheetDragger(
                padding: EdgeInsets.only(left: 8, right: 8, top: 4),
              ),
              CountriesSlidingSheetHeader(),
            ],
          ),
        ),
      ),
    );*/

    return GestureDetector(
      onTap: widget.onHeaderTap,
      child: Material(
        elevation: _elevation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SlidingSheetDragger(
              padding: EdgeInsets.only(left: 8, right: 8, top: 4),
            ),
            UnlockedCountriesSheetHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          widget.onPanelStartScroll?.call(notification.metrics);
        } else if (notification is ScrollUpdateNotification) {
          widget.onPanelUpdateScroll?.call(notification.metrics);
        } else if (notification is ScrollEndNotification) {
          widget.onPanelEndScroll?.call(notification.metrics);
        }

        return true;
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return CountryList(
              countries: state.countries,
              controller: _scrollController,
              shrinkWrap: false,
              onTap: widget.onCountryTap,
              disabled: (country) => country.unlocked,
              buildTrailing: (Country country) {
                return Icon(
                  country.unlocked
                      ? Icons.lock_open_outlined
                      : Icons.lock_outline,
                  color: country.unlocked ? Colors.green : Colors.grey,
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? 8 : 0;
    if (_elevation != newElevation) {
      setState(() => _elevation = newElevation);
    }
  }
}

class UnlockedCountriesSheetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Freigeschaltene Länder',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  state is ProfileLoaded
                      ? Text(
                          '${state.countries.where((country) => country.unlocked).toList().length} von ${state.countries.length} Ländern freigeschaltet',
                          style: TextStyle(
                            color: Colors.green.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Text('Loading...')
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
