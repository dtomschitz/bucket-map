part of countries.widgets;

enum CountriesSlidingSheetMode { unlock, search }

class CountriesSlidingSheet extends StatefulWidget {
  CountriesSlidingSheet({
    this.body,
    this.controller,
    this.animationController,
    this.mode,
    this.onHeaderTap,
    this.onCountryTap,
    this.onPanelSlide,
    this.onPanelClose,
    this.onPanelStartScroll,
    this.onPanelUpdateScroll,
    this.onPanelEndScroll,
  });

  final Widget body;
  final PanelController controller;
  final AnimationController animationController;
  final CountriesSlidingSheetMode mode;

  final void Function() onHeaderTap;
  final void Function(double progress) onPanelSlide;
  final void Function() onPanelClose;
  final void Function(ScrollMetrics metrics) onPanelStartScroll;
  final void Function(ScrollMetrics metrics) onPanelUpdateScroll;
  final void Function(ScrollMetrics metrics) onPanelEndScroll;

  final void Function(Country) onCountryTap;

  @override
  State createState() => _CountriesSlidingSheetState();
}

class _CountriesSlidingSheetState extends State<CountriesSlidingSheet> {
  final ScrollController _scrollController = new ScrollController();
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = widget.animationController;
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight =
        MediaQuery.of(context).size.height + kBottomNavigationBarHeight;

    return SlidingUpPanel(
      controller: widget.controller,
      scrollController: _scrollController,
      animationController: widget.animationController,
      maxHeight: maxHeight,
      backdropEnabled: true,
      parallaxEnabled: true,
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
    return GestureDetector(
      onTap: widget.onHeaderTap,
      child: Material(
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
    );
  }

  Widget _buildPanel() {
    return NotificationListener<ScrollNotification>(
      // ignore: missing_return
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          widget.onPanelStartScroll?.call(notification.metrics);
        } else if (notification is ScrollUpdateNotification) {
          widget.onPanelUpdateScroll?.call(notification.metrics);
        } else if (notification is ScrollEndNotification) {
          widget.onPanelEndScroll?.call(notification.metrics);
        }
      },
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              0.3,
              0.8,
              curve: Curves.ease,
            ),
          ),
        ),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return SafeArea(
                child: CountryList(
                  countries: state.countries,
                  controller: _scrollController,
                  shrinkWrap: false,
                  onTap: widget.onCountryTap,
                  disabled: (country) {
                    if (widget.mode == CountriesSlidingSheetMode.search) {
                      return false;
                    }

                    return country.unlocked;
                  },
                  buildTrailing: (Country country) {
                    if (widget.mode == CountriesSlidingSheetMode.search) {
                      return Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey,
                      );
                    }

                    return Icon(
                      country.unlocked
                          ? Icons.lock_open_outlined
                          : Icons.lock_outline,
                      color: country.unlocked ? Colors.green : Colors.grey,
                    );
                  },
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}

class CountriesSlidingSheetHeader extends StatelessWidget {
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
