import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_current_position/data/geolocation/geolocation_repository.dart';

part 'geolocation_event.dart';
part 'geolocation_state.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  final GeolocationRepository _geolocationRepository;
  StreamSubscription? _geolocationSubscription;

  GeolocationBloc({
    required GeolocationRepository geolocationRepository,
  })  : _geolocationRepository = geolocationRepository,
        super(GeolocationLoading()) {
    on<LoadGeolocation>(_onLoadMap);
    on<UpdateGeolocation>(_onChangeLocation);
  }

  void _onLoadMap(
    LoadGeolocation event,
    Emitter<GeolocationState> emit,
  ) async {
    _geolocationSubscription?.cancel();

    final Position position = await _geolocationRepository.getCurrentLocation();

    add(UpdateGeolocation(position: position));
  }

  void _onChangeLocation(
    UpdateGeolocation event,
    Emitter<GeolocationState> emit,
  ) async {
    emit(GeolocationLoaded(position: event.position));
  }

  @override
  Future<void> close() {
    _geolocationSubscription?.cancel();
    return super.close();
  }
}
