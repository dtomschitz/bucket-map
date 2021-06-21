import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountriesSearchAppBar extends StatelessWidget with PreferredSizeWidget {
  CountriesSearchAppBar({
    this.mode,
    this.controller,
    this.animationController,
    this.backgroundColor,
    this.onSearchBarTap,
    this.onSearchBarClose,
  });

  final CountriesScreenMode mode;
  final TextEditingController controller;
  final AnimationController animationController;

  final Color backgroundColor;

  final void Function() onSearchBarTap;
  final void Function() onSearchBarClose;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
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
                  onPressed: () => onSearchBarClose?.call(),
                ),
              ),
            ),
            SearchBar(
              mode: mode,
              controller: controller,
              onSearchBarTap: onSearchBarTap,
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
  SearchBar({this.mode, this.controller, this.onSearchBarTap});

  final CountriesScreenMode mode;
  final TextEditingController controller;
  final void Function() onSearchBarTap;

  @override
  Widget build(BuildContext context) {
    print(mode);
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 16, left: 16),
          child: CountriesTextField(
            controller: controller,
            readOnly: mode != CountriesScreenMode.unlock,
            onTap: onSearchBarTap?.call,
            onValueChange: (value) {
              BlocProvider.of<FilteredCountriesBloc>(context)
                  .add(UpdateCountriesFilter(value));
            },
          ),
        ),
      ),
    );
  }
}

class CountriesTextField extends StatefulWidget {
  CountriesTextField({
    this.controller,
    this.readOnly,
    this.onTap,
    this.onFocusChange,
    this.onValueChange,
  });

  final TextEditingController controller;
  final bool readOnly;

  final Function() onTap;
  final Function(bool focus) onFocusChange;
  final Function(String value) onValueChange;

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
      readOnly: widget.readOnly ?? false,
      autofocus: false,
      onTap: widget.onTap?.call,
      decoration: InputDecoration(
        labelText: _isEmpty && !hasFocus ? 'Nach Land suchen' : null,
        border: InputBorder.none,
        icon: Icon(Icons.search_outlined),
      ),
    );
  }
}
