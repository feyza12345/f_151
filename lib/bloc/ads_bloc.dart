import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/enums/boosts.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsBloc extends Cubit<List<AdvertisementModel>> {
  AdsBloc() : super([]);

  Future refresh() async {
    clear();
    await FirebaseFirestore.instance
        .collection('ads')
        .where('endDate', isGreaterThan: DateTime.now())
        .get()
        .then((event) {
      final docs =
          event.docs.map((e) => AdvertisementModel.fromMap(e.data())).toList();
      docs.sort((a, b) {
        final boostsA = a.boostsMap?[Boosts.onTop];
        final boostsB = b.boostsMap?[Boosts.onTop];

        if (boostsA == null && boostsB == null) {
          return 0;
        } else if (boostsA == null) {
          return 1;
        } else if (boostsB == null) {
          return -1;
        } else {
          return boostsA.compareTo(boostsB);
        }
      });
      emit(docs);
      debugPrint('@@@@@@ Ilanlar Yenilendi @@@@@@@');
    });
  }

  clear() => emit([]);
}
