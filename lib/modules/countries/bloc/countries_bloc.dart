import 'package:bucket_map/models/country.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geojson/geojson.dart';
import 'package:bucket_map/modules/countries/bloc/bloc.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc(CountriesState initialState) : super(initialState);

  @override
  Stream<CountriesState> mapEventToState(CountriesEvent event) async* {
    // TODO: implement mapEventToState
  
  }

  Stream<CountriesState> _mapTodosLoadedToState() async* {
    try {
      final geo = GeoJson();
      final data = await rootBundle.loadString('assets/countries.geojson');

      await geo.parse(data, verbose: true);
      final List<GeoJsonPolygon> polygons = geo.polygons;
      //final List<Country> countries = 
    
    } catch (_) {
    }
  }
}
