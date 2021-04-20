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
    with SingleTickerProviderStateMixin {
  bool _isFullscreen = false;

  double _screenHeight;
  double _initFabHeight;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  bool _elevateAppBar = false;
  bool _highlightAppBar = false;

  bool _smallSheetHeader = true;

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
        /*return SlidingSheet(
          elevation: _isFullscreen ? 0 : 8,
          closeOnBackdropTap: true,
          cornerRadius: 16,
          cornerRadiusOnFullscreen: 0,     
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [
              SnapSpec.headerSnap,
              SnapSpec.expanded,
            ],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          listener: (state) {},
          body: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: SheetListenerBuilder(
                // buildWhen can be used to only rebuild the widget when needed.
                buildWhen: (oldState, newState) =>
                    oldState.isAtTop != newState.isAtTop,
                builder: (context, state) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: _isFullscreen
                          ? BorderSide(color: Colors.grey, width: 1.0)
                          : BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: _isFullscreen ? 0 : 4,
                    child: Container(
                      height: 46,
                      width: double.infinity,
                      padding: EdgeInsets.only(right: 16, left: 16),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.search_outlined),
                          ),
                          Text('Search')
                        ],
                      ),
                    ),
                  );
                },
              ),
              elevation: _isFullscreen ? 5 : 0,
              backgroundColor: _isFullscreen
                  ? Theme.of(context).appBarTheme.backgroundColor
                  : Colors.transparent,
            ),
            body: CountriesMap(
              fabHeight: _fabHeight,
            ),
          ),
          headerBuilder: _buildHeader,
          builder: (context, state) {
            return Column(
              children: [
                for (int i = 0; i < 20; i++)
                  ListTile(
                    title: Text('test'),
                  )
              ],
            );
          },
        );*/

        /*return Scaffold(
          extendBodyBehindAppBar: true,
          // bottomSheet: ,
          appBar: AppBar(
            title: Card(
              shape: RoundedRectangleBorder(
                side: _isFullscreen
                    ? BorderSide(color: Colors.grey, width: 1.0)
                    : BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: _isFullscreen ? 0 : 4,
              child: Container(
                height: 46,
                width: double.infinity,
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.search_outlined),
                    ),
                    Text('Search')
                  ],
                ),
              ),
            ),
            elevation: _isFullscreen ? 5 : 0,
            backgroundColor: _isFullscreen
                ? Theme.of(context).appBarTheme.backgroundColor
                : Colors.transparent,
          ),
          body: SlidingSheet(
            elevation: _isFullscreen ? 0 : 8,
            closeOnBackdropTap: true,
            cornerRadius: 16,
            cornerRadiusOnFullscreen: 0,
            addTopViewPaddingOnFullscreen: true,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [
                SnapSpec.headerSnap,
                SnapSpec.expanded,
              ],
              positioning: SnapPositioning.relativeToSheetHeight,
            ),
            listener: (state) {},
            body: CountriesMap(
              fabHeight: _fabHeight,
            ),
            headerBuilder: _buildHeader,
            builder: (context, state) {
              return Column(
                children: [
                  for (int i = 0; i < 20; i++)
                    ListTile(
                      title: Text('test'),
                    )
                ],
              );
            },
          ),
        );*/

        return Scaffold(
          body: Stack(
            children: [
              CountriesMap(),
              SlidingSheet(
                elevation: 8,
                closeOnBackdropTap: true,
                cornerRadius: 16,
                cornerRadiusOnFullscreen: 0,
                addTopViewPaddingOnFullscreen: true,
                backdropColor: Colors.grey.shade800,
                liftOnScrollHeaderElevation: 8, 
                snapSpec: const SnapSpec(
                  snap: true,
                  snappings: [
                    SnapSpec.headerSnap,
                    SnapSpec.expanded,
                  ],
                  positioning: SnapPositioning.relativeToSheetHeight,
                ),
                listener: (state) {},
                body: CountriesMap(
                  fabHeight: _fabHeight,
                ),
                headerBuilder: _buildHeader,
                builder: (context, state) {
                  return Column(
                    children: [
                      for (int i = 0; i < 20; i++)
                        ListTile(
                          title: Text('test'),
                        )
                    ],
                  );
                },
              ),
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 500),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: _isFullscreen
                            ? BorderSide(color: Colors.grey, width: 1.0)
                            : BorderSide(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: _isFullscreen ? 0 : 4,
                      child: Container(
                        height: 46,
                        width: double.infinity,
                        padding: EdgeInsets.only(right: 16, left: 16),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(Icons.search_outlined),
                            ),
                            Text('Search')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, SheetState state) {
    return SheetListenerBuilder(
      buildWhen: (oldState, newState) => oldState.isAtTop != newState.isAtTop,
      builder: (context, state) {
        print(state.extent);
        return Material(
          color: Theme.of(context).appBarTheme.backgroundColor,
          elevation: !state.isAtTop ? 7 : 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4, top: 4, right: 4),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 26,
                    height: 4,
                    color: Colors.grey.withOpacity(
                      .5 * (1 - interval(0.7, 1.0, state.progress)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Freigeschaltene Länder',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '15 von 195 Ländern freigeschaltet',
                      style: TextStyle(
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*return Material(
          child: SlidingSheet(
            elevation: _isFullscreen ? 0 : 8,
            closeOnBackdropTap: true,
            cornerRadius: 16,
            cornerRadiusOnFullscreen: 0,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [
                SnapSpec.headerSnap,
                0.6,
                SnapSpec.expanded,
              ],
              positioning: SnapPositioning.relativeToSheetHeight,
            ),
            listener: (state) {
              print(state.progress);

              if (state.progress == 1.0) {
                setState(() {
                  _isFullscreen = true;
                });
              }

              if (state.progress < 1.0 && _isFullscreen) {
                setState(() {
                  _isFullscreen = false;
                });
              }
              /*double progress = state.progress;

              setState(() {
                if (state.progress >= 0.9) {
                  _isFullscreen = true;
                } else {
                  _isFullscreen = false;
                }

                _fabHeight =
                    progress * (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
              });*/
            },
            body: Scaffold(
              extendBodyBehindAppBar: true,
              // bottomSheet: ,
              appBar: AppBar(
                title: Card(
                  shape: RoundedRectangleBorder(
                    side: _isFullscreen
                        ? BorderSide(color: Colors.grey, width: 1.0)
                        : BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: _isFullscreen ? 0 : 4,
                  child: Container(
                    height: 46,
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 16, left: 16),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.search_outlined),
                        ),
                        Text('Search')
                      ],
                    ),
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: CountriesMap(),
            ),
            headerBuilder: _buildHeader,
            builder: (context, state) {
              return Column(
                children: [
                  for (int i = 0; i < 20; i++)
                    ListTile(
                      title: Text('test'),
                    )
                ],
              );
            },
          ),
        );*/
/*return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Card(
              shape: RoundedRectangleBorder(
                side: _elevateAppBar
                    ? BorderSide(color: Colors.grey, width: 1.0)
                    : BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: _elevateAppBar ? 0 : 4,
              child: Container(
                height: 46,
                width: double.infinity,
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.search_outlined),
                    ),
                    Text('Search')
                  ],
                ),
              ),
            ),
            backgroundColor:
                _highlightAppBar ? Colors.white : Colors.transparent,
            elevation: _elevateAppBar ? 4 : 0,
          ),
          body: Stack(
            children: [
              CountriesMap(),
              SizedBox.expand(
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    if (notification.extent > .87 && !_highlightAppBar) {
                      setState(() {
                        _highlightAppBar = true;
                      });
                    }

                    if (notification.extent < .87 && _highlightAppBar) {
                      setState(() {
                        _highlightAppBar = false;
                      });
                    }

                    if (notification.extent == 1.0 && !_elevateAppBar) {
                      setState(() => _elevateAppBar = true);
                    }

                    if (notification.extent < 1.0 && _elevateAppBar) {
                      setState(() => _elevateAppBar = false);
                    }

                    print("${notification.extent}");
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: .1,
                    minChildSize: .1,
                    maxChildSize: 1,
                    builder: (
                      BuildContext context,
                      ScrollController scrollController,
                    ) {
                      return CustomScrollView(
                        controller: scrollController,
                        slivers: <Widget>[
                          SliverAppBar(
                            title: Text("What's Up?"),
                            backgroundColor: Colors.white,
                            automaticallyImplyLeading: false,
                            primary: false,
                            floating: true,
                            pinned: false,
                            snap: true,
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, idx) => ListTile(
                                title: Text("Nothing much"),
                                subtitle: Text("$idx"),
                              ),
                              childCount: 100,
                            ),
                          )
                        ],
                      );
                      /*return Material(
                        elevation: 16,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: CustomContainer(
                                    width: 26,
                                    height: 4,
                                    borderRadius: 2,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: 25,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return ListTile(
                                      title: Text('Item $index'),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );*/
                    },
                  ),
                ),
              )
            ],
          ),
        );*/

/*return Scaffold(
          //extendBodyBehindAppBar: true,
          // bottomSheet: ,
          appBar: AppBar(
            title: Card(
              shape: RoundedRectangleBorder(
                side: _isFullscreen
                    ? BorderSide(color: Colors.grey, width: 1.0)
                    : BorderSide(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: _isFullscreen ? 0 : 4,
              child: Container(
                height: 46,
                width: double.infinity,
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.search_outlined),
                    ),
                    Text('Search')
                  ],
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SlidingSheet(
            elevation: _isFullscreen ? 0 : 8,
            closeOnBackdropTap: true,
            cornerRadius: 16,
            cornerRadiusOnFullscreen: 0,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [
                SnapSpec.headerSnap,
                0.6,
                SnapSpec.expanded,
              ],
              positioning: SnapPositioning.relativeToSheetHeight,
            ),
            listener: (state) {
              print(state.progress);

              if (state.progress == 1.0) {
                setState(() {
                  _isFullscreen = true;
                });
              }

              if (state.progress < 1.0 && _isFullscreen) {
                setState(() {
                  _isFullscreen = false;
                });
              }
              /*double progress = state.progress;

              setState(() {
                if (state.progress >= 0.9) {
                  _isFullscreen = true;
                } else {
                  _isFullscreen = false;
                }

                _fabHeight =
                    progress * (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
              });*/
            },
            body: CountriesMap(
              fabHeight: _fabHeight,
            ),
            headerBuilder: _buildHeader,
            builder: (context, state) {
              return Column(
                children: [
                  for (int i = 0; i < 20; i++)
                    ListTile(
                      title: Text('test'),
                    )
                ],
              );
            },
          ),
        );
      },
    );*/

/*return Material(
          child: SlidingSheet(
            headerBuilder: _buildHeader,
            elevation: 8,
            cornerRadius: 16,
            cornerRadiusOnFullscreen: 0,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.1, 0.4, 1.0],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            listener: (state) {
              setState(() {
                _fabHeight =
                    state.progress * (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
              });
            },
            body: Scaffold(
              /*appBar: AppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),*/
              appBar: SearchBar(),
              body: CountriesMap(),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(
                  bottom: _fabHeight >= screenHeight * 0.4
                      ? screenHeight * 0.4
                      : _fabHeight,
                ),
                child: ExpandableFloatingActionButton(
                  children: [
                    FloatingActionButton(
                      heroTag: "btn1",
                      child: Icon(Icons.create),
                      onPressed: () {},
                    ),
                    FloatingActionButton(heroTag: "btn2", onPressed: () {}),
                    FloatingActionButton(heroTag: "btn3", onPressed: () {}),
                  ],
                  distance: 70.0,
                  initialOpen: false,
                ),
              ),
            ),
            builder: (context, state) {
              // This is the content of the sheet that will get
              // scrolled, if the content is bigger than the available
              // height of the sheet.
              return Container(
                height: 1200,
                child: Text('TEst'),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, SheetState state) {
    return CustomContainer(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shadowColor: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.topCenter,
              child: CustomContainer(
                width: 26,
                height: 4,
                borderRadius: 2,
                color: Colors.grey.withOpacity(
                  .5 * (1 - interval(0.7, 1.0, state.progress)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Freigeschaltene Länder',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '15 von 195 Ländern freigeschaltet',
                  style: TextStyle(
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
