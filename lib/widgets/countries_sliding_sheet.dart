import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CountriesSlidingSheet extends StatefulWidget {
  CountriesSlidingSheet({this.body, this.onSlidingSheetCreated, this.listener});

  final Widget body;
  final Function(SheetController controller) onSlidingSheetCreated;
  final Function(SheetState state) listener;

  @override
  State createState() => _CountriesSlidingSheetState();
}

class _CountriesSlidingSheetState extends State<CountriesSlidingSheet> {
  final SheetController sheetController = SheetController();
  double _headerOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    widget.onSlidingSheetCreated?.call(sheetController);
  }

  @override
  Widget build(BuildContext context) {
    return SlidingSheet(
      controller: sheetController,
      elevation: 8,
      closeOnBackdropTap: true,
      cornerRadius: 16,
      cornerRadiusOnFullscreen: 0,
      addTopViewPaddingOnFullscreen: true,
      liftOnScrollHeaderElevation: 8,
      closeOnBackButtonPressed: true,
      snapSpec: const SnapSpec(
        snap: true,
        snappings: [
          SnapSpec.headerSnap,
          SnapSpec.expanded,
        ],
        positioning: SnapPositioning.relativeToSheetHeight,
      ),
      listener: (state) {
        if (state.progress > 0.8 && _headerOpacity != 0) {
          setState(() => _headerOpacity = 0);
        }

        if (state.progress < 0.8 && _headerOpacity == 0) {
          setState(() => _headerOpacity = 1);
        }

        widget.listener?.call(state);
      },
      body: widget.body,
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
    );
  }

  Widget _buildHeader(BuildContext context, SheetState state) {
    return SheetListenerBuilder(
      buildWhen: (oldState, newState) => oldState.isAtTop != newState.isAtTop,
      builder: (context, state) {
        return Material(
          color: Theme.of(context).appBarTheme.backgroundColor,
          elevation: !state.isAtTop ? 7 : 0.0,
          child: AnimatedOpacity(
            opacity: _headerOpacity,
            duration: Duration(milliseconds: 250),
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
                      color: Colors.grey,
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
          ),
        );
      },
    );
  }
}
