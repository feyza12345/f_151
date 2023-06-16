// ignore_for_file: public_member_api_docs, sort_constructors_first

class PersonModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;

  PersonModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
  });

  static PersonModel get empty =>
      PersonModel(id: 'id', name: 'name', email: 'email', phone: 'phone');

  PersonModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
    };
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }
}
