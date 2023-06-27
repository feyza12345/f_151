import 'package:f151/models/messages_model.dart';

class ChatModel {
  final List<String> participantIds;
  final MessagesModel lastMessage;

  ChatModel({
    required this.participantIds,
    required this.lastMessage,
  });

  ChatModel copyWith({
    List<String>? participantIds,
    MessagesModel? lastMessage,
  }) {
    return ChatModel(
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'participantIds': participantIds,
      'lastMessage': lastMessage.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      participantIds:
          List<String>.from((map['participantIds'] as List<dynamic>)),
      lastMessage:
          MessagesModel.fromMap(map['lastMessage'] as Map<String, dynamic>),
    );
  }
}
