part of auth.register.views;

class SummaryView extends StatelessWidget {
  SummaryView({this.onPreviouseView});

  final Function() onPreviouseView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return ListViewContainer(
          title: 'Zusammenfassung',
          children: [
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('${state.firstName} ${state.lastName}'),
            ),
            ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text(state.email.value ?? ''),
            ),
            ListTile(
              leading: Icon(Icons.my_location_outlined),
              title: Text(state.country.name),
            ),
            SizedBox(height: 32),
            BottomActions(
              children: [
                TextButton(
                  child: Text('Zurück'),
                  onPressed: onPreviouseView?.call,
                ),
                ElevatedButton(
                  child: Text('Konto anlegen'),
                  onPressed: () async {
                    final success =
                        await context.read<RegisterCubit>().registerUser();

                    if (success) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
