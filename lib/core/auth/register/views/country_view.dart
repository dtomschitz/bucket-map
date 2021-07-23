part of auth.register.views;

class CountryView extends StatelessWidget {
  CountryView({this.onNextView, this.onPreviouseView});

  final Function() onNextView;
  final Function() onPreviouseView;

  final TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return ListViewContainer(
          title: 'Land wählen',
          subtitle: 'Wählen Sie das Land aus, in dem Sie aktuell leben.',
          children: [
            InputField(
              controller: controller,
              readOnly: true,
              onTap: () async {
                final country = await showSearch(
                  context: context,
                  delegate: CountrySearchDelegate(),
                );

                context.read<RegisterCubit>().countryChanged(country);
                controller.text = country.name;
              },
              labelText: 'Land wählen',
            ),
            SizedBox(height: 32),
            BottomActions(
              children: [
                TextButton(
                  child: Text('Zurück'),
                  onPressed: onPreviouseView?.call,
                ),
                ElevatedButton(
                  child: Text('Weiter'),
                  onPressed: onNextView?.call,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
