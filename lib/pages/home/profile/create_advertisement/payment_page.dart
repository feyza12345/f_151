import 'package:f151/enums/boosts.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/widgets/ad_list_card.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final AdvertisementModel advertisement;
  final Map<Boosts, int> selectedBoosts;
  const PaymentPage(
      {required this.advertisement, required this.selectedBoosts, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Özet'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('İlan'),
                  AdListCard(model: advertisement),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Seçilen Boostlar'),
                  ...List.generate(selectedBoosts.length, (index) {
                    final boost = selectedBoosts.entries.toList()[index];
                    return ListTile(
                      title: Text(boost.key.title),
                      trailing: Text(
                          '${(boost.key.feeForAWeek * boost.value).toInt().toString()}₺'),
                    );
                  })
                ],
              )),
        ],
      ),
    );
  }
}
