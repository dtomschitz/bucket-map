part of sheets;

class EditPinBottomSheet extends StatelessWidget {
  EditPinBottomSheet({this.pin});
  final Pin pin;

  static Future<T> show<T>(BuildContext context, Pin pin) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return EditPinBottomSheet(pin: pin);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      title: pin.name,
      children: [
        ListTile(
          leading: CenteredIcon(
            icon: Icon(Icons.add_outlined),
          ),
          title: Text(
            'Du hast diesen Pin am ${Utils.formatDate(pin.dateTime)} erstellt',
          ),
        ),
        LocationListTile(
          title: Text('Koordinaten'),
          coordinates: pin.toLatLng(),
        ),
        SizedBox(height: 16),
        ListTile(
          leading: CenteredIcon(icon: Icon(Icons.edit_outlined)),
          title: Text('Bearbeiten'),
          onTap: () {
            ModifyPinScreen.show(context, pin);
          },
        ),
        ListTile(
          leading: CenteredIcon(icon: Icon(Icons.map_outlined)),
          title: Text('Land ändern'),
          onTap: () async {
            await EditPinCountryDialog.show(context, pin);
          },
        ),
        Divider(),
        ListTile(
          leading: CenteredIcon(icon: Icon(Icons.delete_outline)),
          title: Text('Löschen'),
          onTap: () async {
            var delete = await DeletePinDialog.show(context, pin);
            if (delete) {
              BlocProvider.of<PinsBloc>(context).add(DeletePin(pin: pin));
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
