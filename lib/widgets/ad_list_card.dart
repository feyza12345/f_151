import 'dart:io';

import 'package:f151/constants/constants.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/pages/home/homepage/advertisement/advertisement_page.dart';
import 'package:flutter/material.dart';

class AdListCard extends StatelessWidget {
  final AdvertisementModel model;

  const AdListCard({
    super.key,
    required this.model,
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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AdvertisementPage(model, true))),
            child: Row(
              children: [
                Hero(
                  tag: model.photoUrlList[0],
                  child: Container(
                    color: kEmptyAdvertisementColor,
                    width: 150,
                    height: 150,
                    child: model.photoUrlList[0].isEmpty
                        ? null
                        : model.photoUrlList[0].contains('://')
                            ? Image.network(
                                model.photoUrlList[0],
                                fit: BoxFit.cover,
                              )
                            : Image.file(File(model.photoUrlList[0]),
                                fit: BoxFit.cover),
                  ),
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
                          model.title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          model.shortDescription,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          model.name,
                          style: const TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('₺${model.fee}'),
                          ),
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
