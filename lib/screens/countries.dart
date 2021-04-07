import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/widgets/map.dart';
import 'package:bucket_map/utils/interval.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class CountriesScreen extends StatefulWidget {
  @override
  State createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final mapKey = GlobalKey();

  SheetController controller = SheetController();

  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SlidingSheet(
        duration: const Duration(milliseconds: 900),
        controller: controller,
        color: Colors.white,
        shadowColor: Colors.black26,
        elevation: 12,
        maxWidth: 500,
        cornerRadius: 16,
        cornerRadiusOnFullscreen: 0.0,
        closeOnBackdropTap: true,
        closeOnBackButtonPressed: true,
        addTopViewPaddingOnFullscreen: true,
        isBackdropInteractable: true,
        snapSpec: SnapSpec(
          snap: true,
          positioning: SnapPositioning.relativeToAvailableSpace,
          snappings: const [
            SnapSpec.headerFooterSnap,
            0.4,
            SnapSpec.expanded,
          ],
        ),
        liftOnScrollHeaderElevation: 12.0,
        body: Map(key: mapKey),
        headerBuilder: buildHeader,
        builder: buildChild,
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () {},
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, SheetState state) {
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

  Widget buildChild(BuildContext context, SheetState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var country in countries)
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage('https://flagcdn.com/w160/${country.code}.png'),
              backgroundColor: Colors.grey.shade100,
            ),
            title: Text(country.name),
            trailing: Icon(
              Icons.lock_open_outlined,
              color: Colors.black,
            ),
            onTap: () {},
          )
      ],
    );
  }
}
