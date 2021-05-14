import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CountriesSlidingSheet extends StatefulWidget {
  CountriesSlidingSheet(
      {this.body,
      this.onSlidingSheetCreated,
      this.onPanelSlide,
      this.onPanelStartScroll,
      this.onPanelUpdateScroll,
      this.onPanelEndScroll,
      this.onListItemEyeTap,
      this.onListItemTap});

  final Widget body;
  final Function(PanelController controller) onSlidingSheetCreated;
  final Function(double progress) onPanelSlide;
  final Function(ScrollMetrics metrics) onPanelStartScroll;
  final Function(ScrollMetrics metrics) onPanelUpdateScroll;
  final Function(ScrollMetrics metrics) onPanelEndScroll;
  final Function(Country country) onListItemEyeTap;
  final Function(Country country) onListItemTap;

  @override
  State createState() => _CountriesSlidingSheetState();
}

class _CountriesSlidingSheetState extends State<CountriesSlidingSheet> {
  final PanelController _panelController = PanelController();
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    widget.onSlidingSheetCreated?.call(_panelController);
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight =
        MediaQuery.of(context).size.height + kBottomNavigationBarHeight;

    return SlidingUpPanel(
      controller: _panelController,
      maxHeight: maxHeight,
      backdropEnabled: true,
      backdropColor: Colors.black,    
      onControllerCreated: (scrollController, animationController) {
        _scrollController = scrollController;
      },
      onPanelClosed: () {
        _scrollController.jumpTo(0);
      },
      onPanelSlide: widget.onPanelSlide?.call,
      body: widget.body,
      panelBuilder: (controller) => _buildPanel(controller),
      collapseBuilder: (controller) => _buildHeader(controller),
    );
  }

  Widget _buildHeader(AnimationController controller) {
    return GestureDetector(
      onTap: () {
        _panelController.open();
      },
      child: Material(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: FadeTransition(
          opacity: Tween(begin: 1.0, end: 0.0).animate(controller),
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

  Widget _buildPanel(ScrollController controller) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: NotificationListener<ScrollNotification>(
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
        child: CountryList(
          controller: controller,
          onTap: widget.onListItemTap,
          buildTrailing: (Country country) {
            return Wrap(spacing: 12, children: <Widget>[
              IconButton(
                  icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                  onPressed: () => widget.onListItemEyeTap(country)),
              IconButton(
                  icon: Icon(
                Icons.lock,
                color: Colors.grey,
              ))
            ]);
          },
        ),
      ),
    );
  }
}

class CountriesSlidingSheetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountriesBloc, CountriesState>(
      builder: (context, state) {
        return Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Freigeschaltene Länder',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  state is CountriesLoaded
                      ? Text(
                          '15 von ${state.countries.length} Ländern freigeschaltet',
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
