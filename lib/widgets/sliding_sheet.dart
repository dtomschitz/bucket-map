part of widgets;

enum SlideDirection {
  UP,
  DOWN,
}

enum SheetStateEEE { OPEN, CLOSED }

class SlidingSheetTEst extends StatefulWidget {
  final Widget panel;
  final Widget Function() panelBuilder;
  final Widget Function() collapseBuilder;

  final Widget body;
  final Widget header;
  final Widget footer;

  final double minHeight;
  final double maxHeight;
  final double snapPoint;

  final Border border;
  final BorderRadiusGeometry borderRadius;

  final List<BoxShadow> boxShadow;
  final Color color;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final bool renderPanelSheet;
  final bool panelSnapping;

  final SlidingSheetController controller;
  final AnimationController animationController;
  final ScrollController scrollController;

  final bool backdropEnabled;
  final Color backdropColor;
  final double backdropOpacity;
  final bool backdropTapClosesPanel;

  final void Function(double position) onPanelSlide;
  final VoidCallback onPanelOpened;
  final VoidCallback onPanelClosed;

  final bool parallaxEnabled;
  final double parallaxOffset;
  final bool isDraggable;

  final SlideDirection slideDirection;
  final SheetStateEEE defaultPanelState;

  SlidingSheetTEst({
    Key key,
    this.panel,
    this.panelBuilder,
    this.body,
    this.collapseBuilder,
    this.minHeight = 100.0,
    this.maxHeight = 500.0,
    this.snapPoint,
    this.border,
    this.borderRadius,
    this.boxShadow = const <BoxShadow>[
      BoxShadow(
        blurRadius: 8.0,
        color: Color.fromRGBO(0, 0, 0, 0.25),
      )
    ],
    this.color = Colors.white,
    this.padding,
    this.margin,
    this.renderPanelSheet = true,
    this.panelSnapping = true,
    this.controller,
    this.animationController,
    this.scrollController,
    this.backdropEnabled = false,
    this.backdropColor = Colors.black,
    this.backdropOpacity = 0.5,
    this.backdropTapClosesPanel = true,
    this.onPanelSlide,
    this.onPanelOpened,
    this.onPanelClosed,
    this.parallaxEnabled = false,
    this.parallaxOffset = 0.1,
    this.isDraggable = true,
    this.slideDirection = SlideDirection.UP,
    this.defaultPanelState = SheetStateEEE.CLOSED,
    this.header,
    this.footer,
  })  : assert(panel != null || panelBuilder != null),
        assert(0 <= backdropOpacity && backdropOpacity <= 1.0),
        assert(snapPoint == null || 0 < snapPoint && snapPoint < 1.0),
        super(key: key);

  @override
  _SlidingSheetTEstState createState() => _SlidingSheetTEstState();
}

class _SlidingSheetTEstState extends State<SlidingSheetTEst>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  ScrollController _scrollController;
  VelocityTracker _velocityTracker = new VelocityTracker();

  bool _scrollingEnabled = false;
  bool _isPanelVisible = true;

  @override
  void initState() {
    super.initState();

    _animationController = widget.animationController != null
        ? widget.animationController
        : new AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
            value: widget.defaultPanelState == SheetStateEEE.CLOSED ? 0.0 : 1.0);

    _animationController = _animationController
      ..addListener(() {
        if (widget.onPanelSlide != null)
          widget.onPanelSlide(_animationController.value);

        if (widget.onPanelOpened != null && _animationController.value == 1.0)
          widget.onPanelOpened();

        if (widget.onPanelClosed != null && _animationController.value == 0.0)
          widget.onPanelClosed();
      });

    _scrollController = widget.scrollController != null
        ? widget.scrollController
        : new ScrollController();

    _scrollController.addListener(() {
      if (widget.isDraggable && !_scrollingEnabled) _scrollController.jumpTo(0);
    });

    widget.controller?._addState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.slideDirection == SlideDirection.UP
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      children: <Widget>[
        widget.body != null
            ? AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Positioned(
                    top: widget.parallaxEnabled ? _getParallax() : 0.0,
                    child: child,
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: widget.body,
                ),
              )
            : Container(),

        !widget.backdropEnabled
            ? Container()
            : GestureDetector(
                onVerticalDragEnd: widget.backdropTapClosesPanel
                    ? (DragEndDetails dets) {
                        // only trigger a close if the drag is towards panel close position
                        if ((widget.slideDirection == SlideDirection.UP
                                    ? 1
                                    : -1) *
                                dets.velocity.pixelsPerSecond.dy >
                            0) _close();
                      }
                    : null,
                onTap: widget.backdropTapClosesPanel ? () => _close() : null,
                child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, _) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: _animationController.value == 0.0
                            ? null
                            : widget.backdropColor.withOpacity(
                                widget.backdropOpacity *
                                    _animationController.value),
                      );
                    }),
              ),

        //the actual sliding part
        !_isPanelVisible
            ? Container()
            : _gestureHandler(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      height: _animationController.value *
                              (widget.maxHeight - widget.minHeight) +
                          widget.minHeight,
                      margin: widget.margin,
                      padding: widget.padding,
                      decoration: widget.renderPanelSheet
                          ? BoxDecoration(
                              border: widget.border,
                              borderRadius: widget.borderRadius,
                              boxShadow: widget.boxShadow,
                              color: widget.color,
                            )
                          : null,
                      child: child,
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      //open panel
                      Positioned(
                          top: widget.slideDirection == SlideDirection.UP
                              ? 0.0
                              : null,
                          bottom: widget.slideDirection == SlideDirection.DOWN
                              ? 0.0
                              : null,
                          width: MediaQuery.of(context).size.width -
                              (widget.margin != null
                                  ? widget.margin.horizontal
                                  : 0) -
                              (widget.padding != null
                                  ? widget.padding.horizontal
                                  : 0),
                          child: Container(
                            height: widget.maxHeight,
                            child: widget.panel != null
                                ? Material(child: widget.panel)
                                : Material(child: widget.panelBuilder()),
                          )),

                      // header
                      widget.header != null
                          ? Positioned(
                              top: widget.slideDirection == SlideDirection.UP
                                  ? 0.0
                                  : null,
                              bottom:
                                  widget.slideDirection == SlideDirection.DOWN
                                      ? 0.0
                                      : null,
                              child: widget.header,
                            )
                          : Container(),

                      widget.footer != null
                          ? Positioned(
                              top: widget.slideDirection == SlideDirection.UP
                                  ? null
                                  : 0.0,
                              bottom:
                                  widget.slideDirection == SlideDirection.DOWN
                                      ? null
                                      : 0.0,
                              child: widget.footer)
                          : Container(),

                      Positioned(
                        top: widget.slideDirection == SlideDirection.UP
                            ? 0.0
                            : null,
                        bottom: widget.slideDirection == SlideDirection.DOWN
                            ? 0.0
                            : null,
                        width: MediaQuery.of(context).size.width -
                            (widget.margin != null
                                ? widget.margin.horizontal
                                : 0) -
                            (widget.padding != null
                                ? widget.padding.horizontal
                                : 0),
                        child: Container(
                          height: widget.minHeight,
                          child: IgnorePointer(
                            ignoring: _isPanelOpen,
                            child: widget.collapseBuilder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  double _getParallax() {
    if (widget.slideDirection == SlideDirection.UP)
      return -_animationController.value *
          (widget.maxHeight - widget.minHeight) *
          widget.parallaxOffset;
    else
      return _animationController.value *
          (widget.maxHeight - widget.minHeight) *
          widget.parallaxOffset;
  }

  Widget _gestureHandler({Widget child}) {
    if (!widget.isDraggable) return child;

    if (widget.panel != null) {
      return GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails dets) =>
            _onGestureSlide(dets.delta.dy),
        onVerticalDragEnd: (DragEndDetails dets) =>
            _onGestureEnd(dets.velocity),
        child: child,
      );
    }

    return Listener(
      onPointerDown: (PointerDownEvent p) =>
          _velocityTracker.addPosition(p.timeStamp, p.position),
      onPointerMove: (PointerMoveEvent p) {
        _velocityTracker.addPosition(p.timeStamp,
            p.position); // add current position for velocity tracking
        _onGestureSlide(p.delta.dy);
      },
      onPointerUp: (PointerUpEvent p) =>
          _onGestureEnd(_velocityTracker.getVelocity()),
      child: child,
    );
  }

  void _onGestureSlide(double dy) {
    if (!_scrollingEnabled) {
      if (widget.slideDirection == SlideDirection.UP)
        _animationController.value -=
            dy / (widget.maxHeight - widget.minHeight);
      else
        _animationController.value +=
            dy / (widget.maxHeight - widget.minHeight);
    }

    if (_isPanelOpen &&
        _scrollController.hasClients &&
        _scrollController.offset <= 0) {
      setState(() {
        if (dy < 0) {
          _scrollingEnabled = true;
        } else {
          _scrollingEnabled = false;
        }
      });
    }
  }

  void _onGestureEnd(Velocity v) {
    double minFlingVelocity = 365.0;
    double kSnap = 8;

    if (_animationController.isAnimating) return;
    if (_isPanelOpen && _scrollingEnabled) return;

    double visualVelocity =
        -v.pixelsPerSecond.dy / (widget.maxHeight - widget.minHeight);

    if (widget.slideDirection == SlideDirection.DOWN) {
      visualVelocity = -visualVelocity;
    }

    double d2Close = _animationController.value;
    double d2Open = 1 - _animationController.value;
    double d2Snap =
        ((widget.snapPoint ?? 3) - _animationController.value).abs();
    double minDistance = min(d2Close, min(d2Snap, d2Open));

    if (v.pixelsPerSecond.dy.abs() >= minFlingVelocity) {
      if (widget.panelSnapping && widget.snapPoint != null) {
        if (v.pixelsPerSecond.dy.abs() >= kSnap * minFlingVelocity ||
            minDistance == d2Snap) {
          _animationController.fling(velocity: visualVelocity);
        } else {
          _flingPanelToPosition(widget.snapPoint, visualVelocity);
        }
      } else if (widget.panelSnapping) {
        _animationController.fling(velocity: visualVelocity);
      } else {
        _animationController.animateTo(
          _animationController.value + visualVelocity * 0.16,
          duration: Duration(milliseconds: 410),
          curve: Curves.decelerate,
        );
      }

      return;
    }

    if (widget.panelSnapping) {
      if (minDistance == d2Close) {
        _close();
      } else if (minDistance == d2Snap) {
        _flingPanelToPosition(widget.snapPoint, visualVelocity);
      } else {
        _open();
      }
    }
  }

  void _flingPanelToPosition(double targetPos, double velocity) {
    final Simulation simulation = SpringSimulation(
        SpringDescription.withDampingRatio(
          mass: 1.0,
          stiffness: 500.0,
          ratio: 1.0,
        ),
        _animationController.value,
        targetPos,
        velocity);

    _animationController.animateWith(simulation);
  }

  Future<void> _close() {
    return _animationController.fling(velocity: -1.0);
  }

  Future<void> _open() {
    return _animationController.fling(velocity: 1.0);
  }

  Future<void> _hide() {
    return _animationController.fling(velocity: -1.0).then((x) {
      setState(() {
        _isPanelVisible = false;
      });
    });
  }

  Future<void> _show() {
    return _animationController.fling(velocity: -1.0).then((x) {
      setState(() {
        _isPanelVisible = true;
      });
    });
  }

  Future<void> _animatePanelToPosition(double value,
      {Duration duration, Curve curve = Curves.linear}) {
    assert(0.0 <= value && value <= 1.0);
    return _animationController.animateTo(value,
        duration: duration, curve: curve);
  }

  Future<void> _animatePanelToSnapPoint(
      {Duration duration, Curve curve = Curves.linear}) {
    assert(widget.snapPoint != null);
    return _animationController.animateTo(widget.snapPoint,
        duration: duration, curve: curve);
  }

  set _panelPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    _animationController.value = value;
  }

  double get _panelPosition => _animationController.value;

  bool get _isPanelAnimating => _animationController.isAnimating;

  bool get _isPanelOpen => _animationController.value == 1.0;

  bool get _isPanelClosed => _animationController.value == 0.0;

  bool get _isPanelShown => _isPanelVisible;
}

class SlidingSheetController {
  _SlidingSheetTEstState _sheetState;

  void _addState(_SlidingSheetTEstState sheetState) {
    this._sheetState = sheetState;
  }

  bool get isAttached => _sheetState != null;

  Future<void> close() {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    return _sheetState._close();
  }

  Future<void> open() {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    return _sheetState._open();
  }

  Future<void> hide() {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    return _sheetState._hide();
  }

  Future<void> show() {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    return _sheetState._show();
  }

  Future<void> animatePanelToPosition(double value,
      {Duration duration, Curve curve = Curves.linear}) {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    assert(0.0 <= value && value <= 1.0);
    return _sheetState._animatePanelToPosition(value,
        duration: duration, curve: curve);
  }

  Future<void> animatePanelToSnapPoint(
      {Duration duration, Curve curve = Curves.linear}) {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    assert(_sheetState.widget.snapPoint != null,
        "SlidingSheetController snapPoint property must not be null");
    return _sheetState._animatePanelToSnapPoint(
        duration: duration, curve: curve);
  }

  set panelPosition(double value) {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    assert(0.0 <= value && value <= 1.0);
    _sheetState._panelPosition = value;
  }

  double get panelPosition {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    return _sheetState._panelPosition;
  }

  /// Returns whether or not the panel is
  /// currently animating.
  bool get isPanelAnimating {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    return _sheetState._isPanelAnimating;
  }

  bool get isPanelOpen {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    return _sheetState._isPanelOpen;
  }

  bool get isPanelClosed {
    assert(isAttached,
        "SlidingSheetController must be attached to a SlidingSheet");
    return _sheetState._isPanelClosed;
  }

  bool get isPanelShown {
    assert(isAttached, "PanelController must be attached to a SlidingSheet");
    return _sheetState._isPanelShown;
  }
}
