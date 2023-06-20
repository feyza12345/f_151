import 'package:f151/models/messages_model.dart';

class ChatModel {
  final String adId;
  final List<String> participantIds;
  final MessagesModel? lastMessage;

  ChatModel({
    required this.adId,
    required this.participantIds,
    this.lastMessage,
  });

  ChatModel copyWith({
    String? adId,
    List<String>? participantIds,
    MessagesModel? lastMessage,
  }) {
    return ChatModel(
      adId: adId ?? this.adId,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adId': adId,
      'participantIds': participantIds,
      'lastMessage': lastMessage?.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      adId: map['adId'] as String,
      participantIds:
          List<String>.from((map['participantIds'] as List<String>)),
      lastMessage: map['lastMessage'] != null
          ? MessagesModel.fromMap(map['lastMessage'] as Map<String, dynamic>)
          : null,
    );
  }
}
