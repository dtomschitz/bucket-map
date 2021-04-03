import 'package:flutter/material.dart';

class Trip {
  final String title;
  final int country;
  final String titleImage;

  Trip({
    @required this.title,
    @required this.country,
    @required this.titleImage,
  });
}

final List<Trip> trips = <Trip>[
  Trip(title: 'Irgendwo', country: 0, titleImage: 'https://www.schoenes-deutschland-info.de/application/files/thumbnails/listview_microsite_2x/7115/0090/0465/Reflex_Verlag_Deutschland_Urlaub_Saarland_Saarschleife_ThinkstockPhotos-640043410.jpg'),
  Trip(title: 'Paris', country: 1, titleImage: 'https://www.impulse.de/wp-content/uploads/2014/07/Frankreich-Knigge-620x340.jpg'),
  Trip(title: 'New York', country: 2, titleImage: 'https://www.travelbook.de/data/uploads/2020/01/gettyimages-1059614218_1580463849-1040x690.jpg'),
];
