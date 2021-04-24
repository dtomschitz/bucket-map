import 'dart:ui';

import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/core/settings/settings_screen.dart';
import 'package:bucket_map/utils/interval.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CountriesScreen extends StatefulWidget {
  @override
  State createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen>
    with TickerProviderStateMixin {
  SheetController _sheetController;

  double _screenHeight;
  double _initFabHeight;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  bool _showCloseCountriesSheetButton = false;
  bool _fullScreenCountriesSheet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _initFabHeight = _screenHeight * 0.12;
    if (_fabHeight == null) _fabHeight = _initFabHeight;
    _panelHeightOpen = _screenHeight * 1;

    return BlocBuilder<CountriesBloc, CountriesState>(
      builder: (context, state) {
        /*return CountriesSlidingSheet(
          body: Scaffold(
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                CountriesMap(
                  fabHeight: _fabHeight,
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AnimatedContainer(
                          width: _showCloseCountriesSheetButton
                              ? kMinInteractiveDimension
                              : 0,
                          duration: Duration(milliseconds: 150),
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: IconButton(
                              icon: Icon(Icons.close_outlined),
                              onPressed: () {
                                setState(() {
                                  _showCloseCountriesSheetButton = false;
                                  _fullScreenCountriesSheet = false;
                                });
                                _sheetController.collapse();
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
                )
              ],
            ),
          ),
          onSlidingSheetCreated: (controller) {
            _sheetController = controller;
          },
          listener: (state) {
            print(state.progress);

            if (state.progress == 1 &&
                !_showCloseCountriesSheetButton &&
                !_fullScreenCountriesSheet) {
              setState(() {
                _showCloseCountriesSheetButton = true;
                _fullScreenCountriesSheet = true;
              });
            }

            if (state.progress < .9 &&
                _showCloseCountriesSheetButton &&
                _fullScreenCountriesSheet) {
              setState(() {
                _showCloseCountriesSheetButton = false;
                _fullScreenCountriesSheet = false;
              });
            }

            /*setState(() {
                    _fabHeight = state.progress *
                            (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
                  });*/
          },
        );*/
        return Scaffold(
          body: Stack(
            children: [
              CountriesMap(
                fabHeight: _fabHeight,
              ),
              CountriesSlidingSheet(
                onSlidingSheetCreated: (controller) {
                  _sheetController = controller;
                },
                listener: (state) {
                  print(state.progress);

                  if (state.progress == 1 &&
                      !_showCloseCountriesSheetButton &&
                      !_fullScreenCountriesSheet) {
                    setState(() {
                      _showCloseCountriesSheetButton = true;
                      _fullScreenCountriesSheet = true;
                    });
                  }

                  if (state.progress < .9 &&
                      _showCloseCountriesSheetButton &&
                      _fullScreenCountriesSheet) {
                    setState(() {
                      _showCloseCountriesSheetButton = false;
                      _fullScreenCountriesSheet = false;
                    });
                  }

                  /*setState(() {
                    _fabHeight = state.progress *
                            (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
                  });*/
                },
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedContainer(
                        width: _showCloseCountriesSheetButton
                            ? kMinInteractiveDimension
                            : 0,
                        duration: Duration(milliseconds: 150),
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: IconButton(
                            icon: Icon(Icons.close_outlined),
                            onPressed: () {
                              setState(() {
                                _showCloseCountriesSheetButton = false;
                                _fullScreenCountriesSheet = false;
                              });
                              _sheetController.collapse();
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
              )
            ],
          ),
        );
      },
    );
  }
}
