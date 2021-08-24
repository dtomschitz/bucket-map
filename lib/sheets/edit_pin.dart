part of sheets;

class EditPinBottomSheet extends StatelessWidget {
  EditPinBottomSheet({this.pin, this.country});

  final Pin pin;
  final Country country;

  static Future<T> show<T>(BuildContext context, {Pin pin, Country country}) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return EditPinBottomSheet(pin: pin, country: country);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      title: pin.name,
      children: [
        CountryListTile(country: country),
        ListTile(
          leading: CenteredIcon(
            icon: Icon(Icons.add_outlined),
          ),
          title: Text(
            'Du hast diesen Pin am ${Utils.formatDate(pin.dateTime)} erstellt',
          ),
        ),
        Divider(),
        LocationListTile(
          title: Text('Koordinaten'),
          coordinates: pin.toLatLng(),
        ),
        ListTile(
          leading: CenteredIcon(icon: Icon(Icons.edit_outlined)),
          title: Text('Bearbeiten'),
          onTap: () async {
            await ModifyPinScreen.show(context, pin: pin, country: country);
            Navigator.pop(context);
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
