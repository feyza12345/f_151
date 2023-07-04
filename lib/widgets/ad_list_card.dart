import 'dart:math';
import 'dart:typed_data';

import 'package:f151/constants/constants.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/pages/home/homepage/advertisement/advertisement_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdListCard extends StatelessWidget {
  final AdvertisementModel advertisementModel;
  final List<Uint8List>? selectedPhotosData;
  final bool? clickable;
  const AdListCard({
    this.selectedPhotosData,
    required this.advertisementModel,
    super.key,
    this.clickable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 150,
          child: InkWell(
            onTap: clickable == false
                ? null
                : () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        AdvertisementPage(advertisementModel, true))),
            child: Row(
              children: [
                Hero(
                  tag: advertisementModel.photoUrlList.isEmpty
                      ? Random().nextInt(100)
                      : advertisementModel.photoUrlList[0],
                  child: Container(
                      color: kEmptyAdvertisementColor,
                      width: 150,
                      height: 150,
                      child: advertisementModel.photoUrlList.isEmpty
                          ? selectedPhotosData != null &&
                                  selectedPhotosData!.isNotEmpty
                              ? Image.memory(selectedPhotosData![0],
                                  fit: BoxFit.cover)
                              : null
                          : Image.network(
                              advertisementModel.photoUrlList[0],
                              fit: BoxFit.cover,
                            )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          advertisementModel.title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          advertisementModel.shortDescription,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          advertisementModel.name,
                          style: const TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('d/M/y').format(
                                  advertisementModel.startDate ??
                                      DateTime.now()),
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 12),
                            ),
                            Text('₺${advertisementModel.fee}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
