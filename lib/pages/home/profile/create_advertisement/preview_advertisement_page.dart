import 'package:f151/models/advertisement_model.dart';
import 'package:f151/pages/home/homepage/advertisement/advertisement_page.dart';
import 'package:flutter/material.dart';

class PreviewAdvertisementPage extends StatelessWidget {
  final AdvertisementModel advertisement;
  const PreviewAdvertisementPage(this.advertisement, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlan Önizleme'),
        centerTitle: true,
      ),
      body: AdvertisementPage(advertisement, false),
    );
  }
}
