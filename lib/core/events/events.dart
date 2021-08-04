library core.events;

import 'dart:async';

import 'package:flutter/material.dart';

part 'event_listener.dart';
part 'event_provider.dart';
part 'event.dart';

void dispatchEvent(BuildContext context, Event event) {
  EventProvider.of(context).dispatch(event);
}
