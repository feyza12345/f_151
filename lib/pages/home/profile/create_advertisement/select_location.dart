import 'package:f151/models/advertisement_model.dart';
import 'package:f151/pages/home/profile/create_advertisement/select_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocation extends StatefulWidget {
  final AdvertisementModel advertisement;
  const SelectLocation(this.advertisement, {super.key});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  final initCameraPosition =
      const CameraPosition(target: LatLng(38.82, 34.88), zoom: 6);
  late GoogleMapController _mapController;
  Position? _currentLocation;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final currentLocation = await Geolocator.getCurrentPosition();
      setState(() {
        _currentLocation = currentLocation;
        _getLocationAddress(
            LatLng(currentLocation.latitude, currentLocation.longitude));
      });
      animateCamera(currentLocation);
    } else {
      final permissionStatus = await Geolocator.requestPermission();
      if (permissionStatus == LocationPermission.always ||
          permissionStatus == LocationPermission.whileInUse) {
        _getCurrentLocation();
      }
    }
  }

  void animateCamera(Position currentLocation) {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(currentLocation.latitude, currentLocation.longitude),
        13,
      ),
    );
  }

  _navigateToClickedLocation(LatLng argument) async {
    setState(() {
      _currentLocation = Position(
          longitude: argument.longitude,
          latitude: argument.latitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
    });
    animateCamera(_currentLocation!);
    _getLocationAddress(argument);
  }

  _getLocationAddress(LatLng argument) async {
    final list =
        await placemarkFromCoordinates(argument.latitude, argument.longitude);
    final placemark = list.first;
    print(placemark);
    setState(() {
      _currentAddress =
          '${placemark.thoroughfare!.length >= 3 ? '${placemark.thoroughfare}, ' : ''} ${placemark.subLocality!.length >= 3 ? '${placemark.subLocality} ,' : ''} ${placemark.subAdministrativeArea!.length >= 3 ? '${placemark.subAdministrativeArea}, ' : ''}${placemark.administrativeArea!.length >= 3 ? '${placemark.administrativeArea}' : ''}';
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.advertisement);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konum Seç'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initCameraPosition,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: _navigateToClickedLocation,
            circles: _currentLocation == null
                ? {}
                : {
                    Circle(
                        fillColor: Colors.red.withOpacity(0.4),
                        strokeColor: Colors.transparent,
                        circleId: const CircleId('circle1'),
                        center: LatLng(_currentLocation!.latitude,
                            _currentLocation!.longitude),
                        radius: 1000)
                  },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  child: const Icon(Icons.location_searching),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          _currentLocation == null
              ? const SizedBox()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: size.width * 0.5,
                        child: ElevatedButton(
                          child: const Text('Bu konumu kullan'),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SelectPhotoPage(
                                          widget.advertisement.copyWith(
                                        lat: _currentLocation!.latitude,
                                        lng: _currentLocation!.longitude,
                                      )))),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      )
                    ],
                  ),
                ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 35,
                ),
                Container(
                  width: size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      _currentAddress ?? 'Konum bekleniyor...',
                      textAlign: TextAlign.center,
                    )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
