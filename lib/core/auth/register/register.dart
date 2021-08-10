import 'package:bucket_map/core/auth/register/cubit/cubit.dart';
import 'package:bucket_map/core/auth/register/views/views.dart';
import 'package:bucket_map/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

  jumpToPage(int page) {
    controller.animateToPage(
      page,
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  static MaterialPageRoute page() {
    return MaterialPageRoute(builder: (context) => RegisterPage());
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
}

/*class CountrySearch extends SearchDelegate<Country> {
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
}*/
