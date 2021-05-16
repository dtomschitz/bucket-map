import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountriesSearchAppBar extends StatelessWidget with PreferredSizeWidget {
  CountriesSearchAppBar({
    this.controller,
    this.animationController,
    this.backgroundColor,
    this.onSearchBarFocused,
    this.onSearchBarClose,
  });

  final TextEditingController controller;
  final AnimationController animationController;

  final Color backgroundColor;

  final void Function() onSearchBarFocused;
  final void Function() onSearchBarClose;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: animationController,
                curve: Interval(
                  0.8,
                  1.0,
                  curve: Curves.ease,
                ),
              ),
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_outlined),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    onSearchBarClose();
                  },
                ),
              ),
            ),
            SearchBar(
              controller: controller,
              onSearchBarFocused: onSearchBarFocused,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SearchBar extends StatelessWidget {
  SearchBar({
    this.controller,
    this.onSearchBarFocused,
  });

  final TextEditingController controller;
  final void Function() onSearchBarFocused;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          height: 46,
          padding: EdgeInsets.only(right: 16, left: 16),
          child: FocusScope(
            child: Focus(
              onFocusChange: (focus) {
                if (focus) onSearchBarFocused();
              },
              child: CountriesTextField(
                controller: controller,
                onValueChange: (value) {
                  BlocProvider.of<FilteredCountriesBloc>(context)
                      .add(UpdateCountriesFilter(value));
                },
                onValueClear: () {
                  controller.clear();
                  FocusScope.of(context).unfocus();
                  BlocProvider.of<FilteredCountriesBloc>(context)
                      .add(ClearCountriesFilter());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CountriesTextField extends StatefulWidget {
  CountriesTextField({
    this.controller,
    this.onFocusChange,
    this.onValueChange,
    this.onValueClear,
  });

  final TextEditingController controller;
  final Function(bool focus) onFocusChange;
  final Function(String value) onValueChange;
  final Function onValueClear;

  @override
  State createState() => _CountriesTextFieldState();
}

class _CountriesTextFieldState extends State<CountriesTextField> {
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() => _isEmpty = widget.controller.text.isEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = FocusScope.of(context).hasFocus;

    return TextField(
      controller: widget.controller,
      onChanged: widget.onValueChange?.call,
      decoration: InputDecoration(
        labelText: _isEmpty && !hasFocus ? 'Nach Land suchen' : null,
        border: InputBorder.none,
        icon: Icon(Icons.search_outlined),
        suffixIcon: !_isEmpty && hasFocus
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: widget.onValueClear?.call,
              )
            : null,
      ),
    );
  }
}
