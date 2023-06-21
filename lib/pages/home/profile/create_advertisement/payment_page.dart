import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/enums/boosts.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/pages/home/profile/create_advertisement/ad_share_success_page.dart';
import 'package:f151/widgets/ad_list_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PaymentPage extends StatelessWidget {
  final AdvertisementModel advertisement;
  final Map<Boosts, int> selectedBoosts;
  const PaymentPage(
      {required this.advertisement, required this.selectedBoosts, super.key});

  @override
  Widget build(BuildContext context) {
    final boosts = {...selectedBoosts};
    boosts.removeWhere((key, value) => value == 0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Özet'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'İlan',
                    style: TextStyle(fontSize: 20),
                  ),
                  AdListCard(model: advertisement),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Boostlar',
                    style: TextStyle(fontSize: 20),
                  ),
                  ...List.generate(boosts.length, (index) {
                    final boost = boosts.entries.toList()[index];
                    return ListTile(
                      leading: Text('${boost.value} Hafta'),
                      title: Text(boost.key.title),
                      trailing: Text(
                          '${(boost.key.feeForAWeek * boost.value).toInt().toString()}₺'),
                    );
                  })
                ],
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Devam'),
            SizedBox(
              height: 5,
            ),
            Icon(Icons.arrow_forward)
          ],
        ),
        onPressed: () async {
          final docId = FirebaseFirestore.instance.collection('ads').doc().id;
          final List<String> urlList = [];
          var lastAdModel = advertisement.copyWith(
              boostsMap: boosts.map((key, value) =>
                  MapEntry(key, DateTime.now().add((7 * value).days))),
              startDate: DateTime.now(),
              endDate: DateTime.now().add(30.days));

          await Future.forEach(advertisement.photoUrlList, (e) async {
            var uploadAndGetUrl = await FirebaseStorage.instance
                .ref('ads')
                .child(docId)
                .putFile(File(e))
                .then((p0) => p0.ref.getDownloadURL());
            urlList.add(uploadAndGetUrl);
          });
          lastAdModel = lastAdModel.copyWith(photoUrlList: urlList);

          await FirebaseFirestore.instance
              .collection('ads')
              .doc(docId)
              .set(lastAdModel.toMap())
              .then((value) => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => AdShareSuccessPage(advertisement)),
                  (route) => route.isFirst));
        },
      ),
    );
  }
}
