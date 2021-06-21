import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/blocs/profile/bloc.dart';
import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
                0.5,
                0.7,
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
        child: FilterdCountriesList(controller: _scrollController)
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
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Freigeschaltene Länder',
                    style: TextStyle(
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
