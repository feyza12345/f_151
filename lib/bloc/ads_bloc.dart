import 'package:f151/models/advertisement_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsBloc extends Cubit<List<AdvertisementModel>> {
  AdsBloc() : super([]);

  refresh(List<AdvertisementModel> newState) async {
    emit(newState);
    return state;
  }
}
