import 'package:f151/components/custom_widgets.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/models/person_model.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  final AdvertisementModel adModel;
  final PersonModel adOwner;
  const ReviewsPage({required this.adOwner, required this.adModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appBar(title: const Text('Yorumlar')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Burada hic yorum bulunamadi 🤷‍♂️'),
            SizedBox(height: 40),
            Text(
                'Asagidaki bilgileri kullanarak bir sayfa tasarimi olusturabilirsiniz'),
            Text(
                'adModel ve adOwner field larini kullanarak bu sayfayi tasarlayabilirsiniz :)')
          ],
        ),
      ),
    );
  }
}
