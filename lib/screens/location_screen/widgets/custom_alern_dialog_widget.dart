import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_current_position/models/user_view_model.dart';

import 'package:my_current_position/constants/api_key.dart';

class CustomAlernDialog extends StatelessWidget {
  CustomAlernDialog(
      {super.key,
      required this.index,
      required this.myLatitude,
      required this.myLongitude,
      required this.mapController,
      required this.polylines,
      required this.callback});
  final VoidCallback callback;
  int index;
  double myLatitude;
  double myLongitude;
  GoogleMapController mapController;
  late Map<PolylineId, Polyline> polylines;

  late PolylinePoints polylinePoints;

  List<LatLng> polylineCoordinates = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(
        init: UserViewModel(),
        builder: (
          controller,
        ) {
          return controller.loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : AlertDialog(
                  content: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image: NetworkImage(
                                  controller.userModel[index].pic,
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.userModel[index].name),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              controller.userModel[index].email,
                              maxLines: 3,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          _createPolylines(
                              myLatitude,
                              myLongitude,
                              controller.userModel[index].userLat,
                              controller.userModel[index].userLng,
                              mapController,
                              context);

                          Navigator.of(context).pop();
                          callback;
                        },
                        icon: const Icon(Icons.map_outlined)),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok'))
                  ],
                );
        });
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
    GoogleMapController mapController,
    BuildContext context,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      ApiKey.apiKey,
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    }

    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.green,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;

    double miny = (startLatitude <= destinationLatitude)
        ? startLatitude
        : destinationLatitude;
    double minx = (startLongitude <= destinationLongitude)
        ? startLongitude
        : destinationLongitude;
    double maxy = (startLatitude <= destinationLatitude)
        ? destinationLatitude
        : startLatitude;
    double maxx = (startLongitude <= destinationLongitude)
        ? destinationLongitude
        : startLongitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
  }
}
