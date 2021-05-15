import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SearchBarType { transparent, flat }

class CountriesSearchAppBar extends StatelessWidget with PreferredSizeWidget {
  CountriesSearchAppBar({
    this.type,
    this.controller,
    this.backgroundColor,
    this.elevation,
    this.onSearchBarFocused,
    this.onClose,
    this.showCloseButton = false,
    this.height = kToolbarHeight,
  });

  final SearchBarType type;
  final TextEditingController controller;

  final Color backgroundColor;
  final double elevation;
  final double height;
  final bool showCloseButton;

  final Function onSearchBarFocused;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      title: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedContainer(
              width: showCloseButton ? kMinInteractiveDimension : 0,
              duration: Duration(milliseconds: 100),
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Icon(Icons.close_outlined),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    onClose();
                  },
                ),
              ),
            ),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  side: type == SearchBarType.flat
                      ? BorderSide(color: Colors.white, width: 1.0)
                      : BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: type == SearchBarType.flat ? 4 : 0,
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
                      Expanded(
                        child: FocusScope(
                          child: Focus(
                            onFocusChange: (focus) {
                              if (focus) onSearchBarFocused();
                            },
                            child: _CountriesTextField(
                              controller: controller,
                              onValueChange: (value) {
                                BlocProvider.of<FilteredCountriesBloc>(context)
                                    .add(FilterUpdated(value));
                              },
                              onValueClear: () {
                                controller.clear();
                                FocusScope.of(context).unfocus();
                                BlocProvider.of<FilteredCountriesBloc>(context)
                                    .add(FilterUpdated(""));
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CountriesTextField extends StatelessWidget {
  _CountriesTextField({
    this.controller,
    this.onValueChange,
    this.onValueClear,
  });

  final TextEditingController controller;

  final Function(String value) onValueChange;
  final Function onValueClear;

  @override
  Widget build(BuildContext context) {
    final hasFocus = FocusScope.of(context).hasFocus;

    return TextField(
      controller: controller,
      onChanged: onValueChange,
      decoration: InputDecoration(
        labelText: !hasFocus ? 'Search country' : null,
        border: InputBorder.none,
        suffixIcon: hasFocus
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: onValueClear,
              )
            : null,
      ),
    );
  }
}
