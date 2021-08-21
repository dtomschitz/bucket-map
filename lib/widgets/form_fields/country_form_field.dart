part of widgets;

class CountryFormField extends StatelessWidget {
  CountryFormField({this.controller, this.onCountryChange});

  final TextEditingController controller;
  final Function(Country country) onCountryChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      validator: (value) => Utils.validateString(
        value,
        message: 'Bitte wählen Sie ihr Heimatland',
      ),
      decoration: InputDecoration(labelText: 'Heimatland'),
      onTap: () async {
        final country = await CountrySearch.show(context);
        if (country != null) {
          controller.text = country.name;
          onCountryChange?.call(country);
        }
      },
    );
  }
}
