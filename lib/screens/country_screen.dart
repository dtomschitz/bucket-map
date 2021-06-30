import 'package:bucket_map/blocs/pins/bloc.dart';
import 'package:bucket_map/dialogs/dialogs.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryScreen extends StatelessWidget {
  CountryScreen({this.country});
  final Country country;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(country.name),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              country.unlocked ? Icons.lock_open_outlined : Icons.lock_outlined,
            ),
          ),
        ],
      ),
      body: BlocBuilder<PinsBloc, PinsState>(
        builder: (context, state) {
          if (state is PinsLoaded) {
            final pins =
                state.pins.where((pin) => pin.country == country.code).toList();

            return ListView(
              padding: EdgeInsets.all(0),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    height: 255,
                    child: CountryPreviewCard(
                      country: country,
                      onTap: () => openCountryMap(context, country, pins),
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: pins.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return PinListTile(pins[index]);
                  },
                )
              ],
            );
          }

          return TopCircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => CreateLocationScreen(),
            ),
          );
        },
      ),
    );
  }

  openCountryMap(BuildContext context, Country country, List<Pin> pins) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, __, ___) {
          return CountryMap(
            country: country,
            pins: pins,
          );
        },
        transitionsBuilder: (context, opacity, a2, child) {
          return FadeTransition(
            opacity: opacity,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 250),
      ),
    );
  }
}

class PinListTile extends StatelessWidget {
  PinListTile(this.pin);
  final Pin pin;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(pin.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {},
      confirmDismiss: (direction) {
        return showDialog<bool>(
          context: context,
          builder: (context) {
            return ConfirmPinDeletionDialog();
          },
        );
      },
      child: ListTile(title: Text(pin.name)),
      background: Container(
        color: Colors.red,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }
}
