import 'package:f151/enums/boosts.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final AdvertisementModel advertisement;
  final Map<Boosts, int> selectedBoosts;
  const PaymentPage(
      {required this.advertisement, required this.selectedBoosts, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ödeme')),
    );
  }
}
