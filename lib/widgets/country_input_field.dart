import 'package:bucket_map/core/auth/widgets/widgets.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CountryInputField extends StatelessWidget {
  CountryInputField({this.controller, this.onCountryChanged});

  final TextEditingController controller;
  final Function(Country country) onCountryChanged;

  @override
  Widget build(BuildContext context) {
    return FormInputField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final country = await showSearch(
          context: context,
          delegate: CountrySearchDelegate(),
        );

        controller.text = country.name;
        this.onCountryChanged(country);
      },
      labelText: 'Land wählen',
    );
  }
}
