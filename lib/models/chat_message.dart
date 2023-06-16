import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String teacherUID;
  final String studentUID;
  final String senderUID;
  final String message;
  final Timestamp timestamp;

  ChatMessage({
    required this.teacherUID,
    required this.studentUID,
    required this.senderUID,
    required this.message,
    required this.timestamp,
  });

  ChatMessage copyWith({
    String? teacherUID,
    String? studentUID,
    String? senderUID,
    String? message,
    Timestamp? timestamp,
  }) {
    return ChatMessage(
      teacherUID: teacherUID ?? this.teacherUID,
      studentUID: studentUID ?? this.studentUID,
      senderUID: senderUID ?? this.senderUID,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'teacherUID': teacherUID,
      'studentUID': studentUID,
      'senderUID': senderUID,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      teacherUID: map['teacherUID'] as String,
      studentUID: map['studentUID'] as String,
      senderUID: map['senderUID'] as String,
      message: map['message'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }
}
