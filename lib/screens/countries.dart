import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CountriesScreen extends StatefulWidget {
  @override
  State createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  PanelController _panelController;

  double _screenHeight;
  double _initFabHeight;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  bool _fullScreenCountriesSheet = false;
  bool _elevateAppHeader = false;
  bool _ignoreOnPanelSlide = false;

  _onSlidingSheetCreated(PanelController controller) {
    _panelController = controller;
  }

  _onPanelSlide(double progress) {
    if (progress == 0.0) {
      setState(() => _ignoreOnPanelSlide = false);
    }

    if (!_ignoreOnPanelSlide) {
      print(progress);

      if (progress > 0.9 && !_fullScreenCountriesSheet) {
        setState(() {
          _fullScreenCountriesSheet = true;
        });
      }

      if (progress < 0.85 && _fullScreenCountriesSheet) {
        setState(() {
          _fullScreenCountriesSheet = false;
        });
      }

      /*if (progress < .3) {
        setState(() {
          _fabHeight =
              progress * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
        });
      }*/
    }
  }

  _onPanelUpdateScroll(ScrollMetrics metrics) {
    if (metrics.extentBefore > 1 && !_elevateAppHeader) {
      setState(() {
        _elevateAppHeader = true;
      });
    }

    if (metrics.extentBefore < 1 && _elevateAppHeader) {
      setState(() {
        _elevateAppHeader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _initFabHeight = _screenHeight * 0.2;
    if (_fabHeight == null) _fabHeight = _initFabHeight;
    _panelHeightOpen = _screenHeight * 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        
        backgroundColor: _fullScreenCountriesSheet
            ? Theme.of(context).appBarTheme.backgroundColor
            : Colors.transparent,
        elevation: _elevateAppHeader ? 8.0 : 0.0,
        title: Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedContainer(
                width: _fullScreenCountriesSheet ? kMinInteractiveDimension : 0,
                duration: Duration(milliseconds: 100),
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: Icon(Icons.close_outlined),
                    onPressed: () {
                      setState(() {
                        _fullScreenCountriesSheet = false;
                        _elevateAppHeader = false;
                        _ignoreOnPanelSlide = true;
                      });
                      _panelController.close();
                    },
                  ),
                ),
              ),
              Expanded(
                child: CountriesSearchBar(
                  type: _fullScreenCountriesSheet
                      ? CountriesSearchBarType.flat
                      : CountriesSearchBarType.elevated,
                ),
              )
            ],
          ),
        ),
      ),
      body: CountriesSlidingSheet(
        body: CountriesMap(fabHeight: _fabHeight),
        onSlidingSheetCreated: _onSlidingSheetCreated,
        onPanelSlide: _onPanelSlide,
        onPanelUpdateScroll: _onPanelUpdateScroll,
      ),
    );
  }
}
