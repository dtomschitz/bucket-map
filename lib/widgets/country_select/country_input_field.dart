part of widgets;

class CountryInputField extends StatelessWidget {
  CountryInputField({this.controller, this.onCountryChanged});

  final TextEditingController controller;
  final Function(Country country) onCountryChanged;

  @override
  Widget build(BuildContext context) {
    return InputField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final country = await showSearch(
          context: context,
          delegate: CountrySearch(),
        );

        controller.text = country.name;
        this.onCountryChanged(country);
      },
      labelText: 'Land wählen',
      
    );
  }
}
