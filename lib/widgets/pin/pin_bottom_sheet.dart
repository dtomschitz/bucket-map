part of widgets;

class LocationCardBottomSheet extends StatelessWidget {
  LocationCardBottomSheet(this.pin);
  final Pin pin;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      title: pin.name,
      children: [
        pin.description != null
            ? ListTile(
                leading: Icon(Icons.description_outlined),
                title: Text(pin.description),
              )
            : Container(),
        SizedBox(height: 32),
        ListTile(
          leading: Icon(Icons.edit_outlined),
          title: Text('Bearbeiten'),
          onTap: () {
            ModifyPinScreen.show(context, pin);
          },
        ),
        ListTile(
          leading: Icon(Icons.map_outlined),
          title: Text('Land ändern'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text('Löschen'),
          onTap: () async {
            BlocProvider.of<PinsBloc>(context).add(RemovePin(pin: pin));
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
