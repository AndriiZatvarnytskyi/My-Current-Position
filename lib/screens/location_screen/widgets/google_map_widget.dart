import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_api_headers/google_api_headers.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/places.dart' as webservice;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_current_position/constants/api_key.dart';
import 'package:my_current_position/bloc/geolocation/geolocation_bloc.dart';
import 'package:my_current_position/screens/location_screen/widgets/address_text_form.dart';
import 'package:my_current_position/screens/location_screen/widgets/custom_alern_dialog_widget.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  late LatLng startLatLng;
  late LatLng destinationLatLng;
  late double myLatitude;
  late double myMarkColor;
  late double myLongitude;

  String location = 'Search';

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  late final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('0'),
      position: const LatLng(48.696483, 2.504762),
      onTap: () {
        simpleDialog(0);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(100),
    ),
    Marker(
      markerId: const MarkerId('1'),
      position: const LatLng(22.720291, 75.887680),
      onTap: () {
        simpleDialog(1);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(100),
    ),
    Marker(
      markerId: const MarkerId('2'),
      position: const LatLng(60.819079, -115.780593),
      onTap: () {
        simpleDialog(2);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(100),
    ),
    Marker(
      markerId: const MarkerId('3'),
      position: const LatLng(6.569845, -1.628535),
      onTap: () {
        simpleDialog(3);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(100),
    ),
  };

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BlocBuilder<GeolocationBloc, GeolocationState>(
              builder: (context, state) {
                if (state is GeolocationLoaded) {
                  myLatitude = state.position.latitude;
                  myLongitude = state.position.longitude;
                  return GoogleMap(
                    markers: Set<Marker>.from(_markers),
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                          state.position.latitude,
                          state.position.longitude,
                        ),
                        zoom: 15),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    polylines: Set<Polyline>.of(polylines.values),
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: AddressForm(
                      onTap: () {
                        setState(() {
                          _searchLocation(context);
                        });
                      },
                      title: location),
                ),
              ),
            ),
            BlocBuilder<GeolocationBloc, GeolocationState>(
              builder: (context, state) {
                if (state is GeolocationLoaded) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, bottom: 10.0),
                          child: ClipOval(
                            child: Material(
                              color: Colors.orange.shade100,
                              child: InkWell(
                                splashColor: Colors.orange,
                                child: const SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Icon(Icons.my_location),
                                ),
                                onTap: () {
                                  mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                        target: LatLng(
                                          state.position.latitude,
                                          state.position.longitude,
                                        ),
                                        zoom: 18.0,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> simpleDialog(int index) async {
    return showDialog<void>(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return BlocBuilder<GeolocationBloc, GeolocationState>(
            builder: (context, state) {
              if (state is GeolocationLoaded) {
                return CustomAlernDialog(
                  callback: () {
                    setState;
                  },
                  polylines: polylines,
                  index: index,
                  myLatitude: state.position.latitude,
                  myLongitude: state.position.longitude,
                  mapController: mapController,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        });
  }

  Future<void> _searchLocation(BuildContext context) async {
    var place = await PlacesAutocomplete.show(
        context: context,
        apiKey: ApiKey.apiKey,
        mode: Mode.overlay,
        types: [],
        strictbounds: false,
        onError: (err) {});

    if (place != null) {
      setState(() {
        location = place.description.toString();
      });

      final plist = webservice.GoogleMapsPlaces(
        apiKey: ApiKey.apiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      String placeid = place.placeId ?? "0";
      final detail = await plist.getDetailsByPlaceId(placeid);
      final geometry = detail.result.geometry!;
      final lat = geometry.location.lat;
      final lang = geometry.location.lng;
      startLatLng = LatLng(lat, lang);

      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: startLatLng, zoom: 17)));
    }
  }
}
