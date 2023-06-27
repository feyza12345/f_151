import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PersonModel {
  final String id;
  final List<String> notificationIds;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;
  final DateTime createDate;
  final DateTime lastEditedDate;

  PersonModel({
    required this.id,
    required this.notificationIds,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
    required this.createDate,
    required this.lastEditedDate,
  });

  static PersonModel get empty => PersonModel(
      id: 'id',
      notificationIds: ['notificationIds'],
      name: 'name',
      email: 'email',
      phone: 'phone',
      createDate: DateTime.now(),
      lastEditedDate: DateTime.now());

  PersonModel copyWith({
    String? id,
    List<String>? notificationIds,
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
    DateTime? createDate,
    DateTime? lastEditedDate,
  }) {
    return PersonModel(
      id: id ?? this.id,
      notificationIds: notificationIds ?? this.notificationIds,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      createDate: createDate ?? this.createDate,
      lastEditedDate: lastEditedDate ?? this.lastEditedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'notificationIds': notificationIds,
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'createDate': Timestamp.fromDate(createDate),
      'lastEditedDate': Timestamp.fromDate(lastEditedDate),
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'] as String,
      notificationIds: (map['notificationIds'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      createDate: (map['createDate'] as Timestamp).toDate(),
      lastEditedDate: (map['lastEditedDate'] as Timestamp).toDate(),
    );
  }
}
