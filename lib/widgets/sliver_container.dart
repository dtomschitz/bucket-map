part of widgets;

class SliverContainer<B extends BlocBase<S>, S> extends StatefulWidget {
  SliverContainer({
    this.appBar,
    this.children = const [],
    this.on,
  });

  final SliverAppBar appBar;
  final List<Widget> children;

  final Function(S state) on;

  @override
  State createState() => _SliverContainerState<B, S>();
}

class _SliverContainerState<B extends BlocBase<S>, S>
    extends State<SliverContainer<B, S>> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      /*listenWhen: (previous, current) {
        return true;
      },*/
      listener: (context, state) {
        print(state);
        final isState = widget.on.call(state);
        print(isState);
        if (isState && !_loaded) {
          setState(() => _loaded = true);
        }
      },
      builder: (context, state) {
        //final isState = widget.on.call(state);

        final progressIndicator = _loaded
            ? [
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [TopCircularProgressIndicator()],
                  ),
                )
              ]
            : [];

        return CustomScrollView(
          physics: _loaded ? null : NeverScrollableScrollPhysics(),
          slivers: [
            widget.appBar,
            ...progressIndicator,
            ...widget.children,
          ],
        );
      },
    );
  }
}
