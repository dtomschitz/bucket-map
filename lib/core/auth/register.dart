import 'package:bucket_map/blocs/profile/bloc.dart';
import 'package:bucket_map/core/auth/cubits/register/cubit.dart';
import 'package:bucket_map/core/auth/repositories/repositories.dart';
import 'package:bucket_map/core/auth/widgets/widgets.dart';
import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class RegisterPage extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

  jumpToPage(int page) {
    controller.animateToPage(
      page,
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (_) => RegisterCubit(
        context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bucket Map'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(6.0),
            child: BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                if (state.loading) {
                  return LinearProgressIndicator();
                }

                return Container();
              },
            ),
          ),
        ),
        body: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            NameView(onNextView: () => jumpToPage(1)),
            EmailView(
              onNextView: () => jumpToPage(2),
              onPreviouseView: () => jumpToPage(0),
            ),
            PasswortView(
              onNextView: () => jumpToPage(3),
              onPreviouseView: () => jumpToPage(1),
            ),
            CountryView(
              onNextView: () => jumpToPage(4),
              onPreviouseView: () => jumpToPage(2),
            ),
            SummaryView(onPreviouseView: () => jumpToPage(3)),
          ],
        ),
      ),
    );
  }

  static MaterialPageRoute page() {
    return MaterialPageRoute(
      builder: (context) => RegisterPage(),
    );
  }
}

class NameView extends StatelessWidget {
  const NameView({this.onNextView});
  final Function() onNextView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final isValid = state.firstName.isNotEmpty && state.lastName.isNotEmpty;

        return ListViewContainer(
          title: 'Konto anlegen',
          subtitle: 'Bitte geben Sie ihren Namen ein.',
          children: [
            InputField(
              onChanged: context.read<RegisterCubit>().firstNameChanged,
              keyboardType: TextInputType.name,
              labelText: 'Vorname',
            ),
            SizedBox(height: 16),
            InputField(
              onChanged: context.read<RegisterCubit>().lastNameChanged,
              keyboardType: TextInputType.name,
              labelText: 'Nachname',
            ),
            SizedBox(height: 32),
            BottomActions(
              children: [
                Spacer(),
                ElevatedButton(
                  child: Text('Weiter'),
                  onPressed: isValid ? onNextView?.call : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class EmailView extends StatelessWidget {
  const EmailView({this.onNextView, this.onPreviouseView});

  final Function() onNextView;
  final Function() onPreviouseView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final isValid = state.emailStatus == FormzStatus.valid;

        return ListViewContainer(
          title: 'Konto anlegen',
          subtitle: 'Bitte geben Sie ihre E-Mail ein.',
          children: [
            InputField(
              onChanged: context.read<RegisterCubit>().emailChanged,
              keyboardType: TextInputType.emailAddress,
              labelText: 'E-Mail',
              errorText: state.error,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text('Zurück'),
                    onPressed: onPreviouseView?.call,
                  ),
                  ElevatedButton(
                    child: Text('Weiter'),
                    onPressed: () async {
                      final exists = await context
                          .read<RegisterCubit>()
                          .checkIfEmailExists();

                      if (exists) return;
                      onNextView?.call();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class PasswortView extends StatelessWidget {
  const PasswortView({this.onNextView, this.onPreviouseView});

  final Function() onNextView;
  final Function() onPreviouseView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final isValid = state.passwordStatus == FormzStatus.valid;

        return ListViewContainer(
          title: 'Passwort wählen',
          subtitle:
              'Erstellen Sie ein starkes Passwort aus Buchstaben, Zahlen und Sonderzeichen.',
          children: [
            InputField(
              onChanged: context.read<RegisterCubit>().passwordChanged,
              obscureText: true,
              labelText: 'Password',
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
                  onPressed: isValid ? onNextView?.call : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

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
                  delegate: CountrySearch(),
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

class CountrySearch extends SearchDelegate<Country> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return CountrySearchList(
      query: query,
      onTap: (country) => close(context, country),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return CountrySearchList(
        query: query, onTap: (country) => close(context, country));
  }
}

class CountrySearchList extends StatelessWidget {
  CountrySearchList({this.query, this.onTap});
  final String query;
  final Function(Country country) onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          List<Country> countries = state.countries.where(
            (country) {
              return country.name.toLowerCase().contains(query.toLowerCase());
            },
          ).toList();

          return ListView.builder(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            itemCount: countries.length,
            itemBuilder: (BuildContext context, int index) {
              final country = countries[index];
              final code = country.code.toLowerCase();

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://flagcdn.com/w160/$code.png'),
                  backgroundColor: Colors.grey.shade100,
                ),
                title: Text(country.name),
                onTap: () => onTap?.call(country),
              );
            },
          );
        }

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 16),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
