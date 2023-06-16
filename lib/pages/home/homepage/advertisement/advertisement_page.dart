import 'dart:io';

import 'package:f151/models/advertisement_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdvertisementPage extends StatefulWidget {
  final AdvertisementModel advertisement;
  final bool isAppBarOn;

  const AdvertisementPage(this.advertisement, this.isAppBarOn, {Key? key})
      : super(key: key);

  @override
  AdvertisementPageState createState() => AdvertisementPageState();
}

class AdvertisementPageState extends State<AdvertisementPage> {
  int currentImageIndex = 0;
  String? _currentAddress;

  @override
  void initState() {
    _getLocationAddress(
        LatLng(widget.advertisement.lat!, widget.advertisement.lng!));
    super.initState();
  }

  Future<void> _getLocationAddress(LatLng argument) async {
    final list =
        await placemarkFromCoordinates(argument.latitude, argument.longitude);
    final placemark = list.first;
    setState(() {
      _currentAddress =
          '${placemark.thoroughfare!.length >= 3 ? '${placemark.thoroughfare}, ' : ''} ${placemark.subLocality!.length >= 3 ? '${placemark.subLocality} ,' : ''} ${placemark.subAdministrativeArea!.length >= 3 ? '${placemark.subAdministrativeArea}, ' : ''}${placemark.administrativeArea!.length >= 3 ? '${placemark.administrativeArea}' : ''}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: widget.isAppBarOn
          ? AppBar(
              title: Text(widget.advertisement.title),
              centerTitle: true,
            )
          : null,
      body: ListView(
        children: [
          Stack(
            children: [
              SizedBox(
                height: size.width,
                width: size.width,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.advertisement.photoUrlList!.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(
                      File(widget.advertisement.photoUrlList![index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  onPageChanged: (value) {
                    setState(() => currentImageIndex = value);
                  },
                ),
              ),
              Positioned(
                right: 5,
                left: 5,
                top: 10,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black54,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        child: Text(
                          '${currentImageIndex + 1}/${widget.advertisement.photoUrlList!.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.advertisement.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.advertisement.shortDescription,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.advertisement.description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ücret: ${widget.advertisement.fee} \$',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Kategori: ${widget.advertisement.category?.name ?? ""}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Cinsiyet: ${widget.advertisement.gender?.name ?? ""}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Konum: ${widget.advertisement.lessonLocation?.name ?? ""}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text('Adres: ${_currentAddress ?? ''}'),
                const SizedBox(height: 10),
                if (widget.advertisement.lat != null &&
                    widget.advertisement.lng != null)
                  SizedBox(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.advertisement.lat!,
                            widget.advertisement.lng!),
                        zoom: 11,
                      ),
                      circles: {
                        Circle(
                          circleId: const CircleId('firstCircle'),
                          radius: 1000,
                          fillColor: Colors.red.withOpacity(0.5),
                          strokeColor: Colors.transparent,
                          center: LatLng(
                            widget.advertisement.lat!,
                            widget.advertisement.lng!,
                          ),
                        ),
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
