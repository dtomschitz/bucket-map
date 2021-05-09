import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CountriesSearchBarType { elevated, flat }

class CountriesSearchBar extends StatefulWidget {
  CountriesSearchBar({this.type, this.onFocused, this.onTextFieldCreated});

  final CountriesSearchBarType type;
  final Function onFocused;
  final Function(TextEditingController textEditingController)
      onTextFieldCreated;

  @override
  State createState() => _CountriesSearchBarState();
}

class _CountriesSearchBarState extends State<CountriesSearchBar> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.onTextFieldCreated?.call(_textEditingController);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: widget.type == CountriesSearchBarType.elevated
            ? BorderSide(color: Colors.white, width: 1.0)
            : BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(50),
      ),
      elevation:
          widget.createState() == CountriesSearchBarType.elevated ? 4 : 0,
      child: Container(
        height: 46,
        width: double.infinity,
        padding: EdgeInsets.only(right: 16, left: 16),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.search_outlined),
            ),
            // Text('Search')
            Expanded(
                child: FocusScope(
                    child: Focus(
              onFocusChange: (focus) {
                if (focus) {
                  widget.onFocused();
                }
              },
              child: TextField(
                controller: _textEditingController,
                onChanged: (inp) {
                  BlocProvider.of<FilteredCountriesBloc>(context)
                      .add(FilterUpdated(inp));
                },
                decoration: InputDecoration(
                  labelText: 'Search country',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _textEditingController.clear();
                      BlocProvider.of<FilteredCountriesBloc>(context)
                          .add(FilterUpdated(""));
                    },
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
            )))
          ],
        ),
      ),
    );
  }
}
