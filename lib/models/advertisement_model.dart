import 'package:f151/enums/genders.dart';
import 'package:f151/models/category_model.dart';

class AdvertisementModel {
  final CategoryModel? category;
  final String name;
  final String title;
  final String shortDescription;
  final String description;
  final int fee;
  final Gender? gender;
  final List<String> photoUrlList;

  AdvertisementModel({
    this.category,
    required this.name,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.fee,
    this.gender,
    required this.photoUrlList,
  });

  AdvertisementModel copyWith({
    CategoryModel? category,
    String? name,
    String? title,
    String? imageUrl,
    String? shortDescription,
    String? description,
    int? fee,
    Gender? gender,
    List<String>? photoUrlList,
  }) {
    return AdvertisementModel(
      category: category ?? this.category,
      name: name ?? this.name,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      fee: fee ?? this.fee,
      gender: gender ?? this.gender,
      photoUrlList: photoUrlList ?? this.photoUrlList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category?.toMap(),
      'name': name,
      'title': title,
      'shortDescription': shortDescription,
      'description': description,
      'fee': fee,
      'gender': gender?.name,
      'photoUrlList': photoUrlList,
    };
  }

  factory AdvertisementModel.fromMap(Map<String, dynamic> map) {
    return AdvertisementModel(
      category: CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
      name: map['name'] as String,
      title: map['title'] as String,
      shortDescription: map['shortDescription'] as String,
      description: map['description'] as String,
      fee: map['fee'] as int,
      gender: map['gender'] != null
          ? Gender.values.firstWhere((element) => element.name == map['gender'])
          : null,
      photoUrlList: List<String>.from((map['photoUrlList'] as List<String>)),
    );
  }
}
