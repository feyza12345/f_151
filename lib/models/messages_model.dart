import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  final String senderId;
  final String content;
  final DateTime timestamp;

  MessagesModel({
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  MessagesModel copyWith({
    String? senderId,
    String? content,
    DateTime? timestamp,
  }) {
    return MessagesModel(
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory MessagesModel.fromMap(Map<String, dynamic> map) {
    return MessagesModel(
      senderId: map['senderId'] as String,
      content: map['content'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
