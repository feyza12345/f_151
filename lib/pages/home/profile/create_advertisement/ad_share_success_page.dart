import 'package:f151/models/advertisement_model.dart';
import 'package:flutter/material.dart';

class AdShareSuccessPage extends StatelessWidget {
  final AdvertisementModel advertisement;
  const AdShareSuccessPage(this.advertisement, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('İlan Paylaşıldı')),
      body: Center(
        child: Text('İlanınız başarıyla paylaşıldı'),
      ),
    );
  }
}
