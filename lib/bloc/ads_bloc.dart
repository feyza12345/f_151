import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/enums/boosts.dart';
import 'package:f151/models/advertisement_model.dart';
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
      docs.sort((a, b) =>
          a.boostsMap![Boosts.onTop]!.compareTo(b.boostsMap![Boosts.onTop]!));
      emit(docs);
      print('@@@@@@ Ilanlar Yenilendi @@@@@@@');
    });
  }

  clear() => emit([]);
}
