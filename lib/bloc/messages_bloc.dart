import 'package:f151/models/messages_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesBloc extends Cubit<List<MessagesModel>> {
  MessagesBloc() : super([]);

  void load(List<MessagesModel> messages) => emit(messages);

  void clear() => emit([]);
}
