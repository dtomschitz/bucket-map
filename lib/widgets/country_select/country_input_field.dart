part of widgets;

class CountryInputField extends StatefulWidget {
  CountryInputField({
    this.controller,
    this.initialCountry,
    this.validator,
    this.onCountryChanged,
  });

  final TextEditingController controller;

  final Country initialCountry;

  final String Function(String) validator;
  final Function(Country country) onCountryChanged;

  @override
  State createState() => _CountryInputFieldState();
}

class _CountryInputFieldState extends State<CountryInputField> {
  final _controller = TextEditingController();

  @override
  initState() {
    super.initState();
    _controller.text = widget.initialCountry?.name;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      validator: widget.validator,
      onTap: () async {
        final country = await showSearch(
          context: context,
          delegate: CountrySearch(),
        );

        _controller.text = country.name;

        widget.controller.text = country.code;
        widget.onCountryChanged?.call(country);
      },
      decoration: InputDecoration(
        prefixIcon: AnimatedContainerSwitcher(
          child: widget.controller.text.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: 8, right: 6),
                  child: CountryAvatar(widget.controller.text),
                )
              : Container(),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 26,
          minHeight: 26,
        ),
        labelText: 'Land wählen',
      ),
    );
  }
}
