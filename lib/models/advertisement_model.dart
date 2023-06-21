import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/enums/boosts.dart';
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
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<Boosts, DateTime>? boostsMap;

  AdvertisementModel({
    this.category,
    required this.name,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.fee,
    this.gender,
    required this.photoUrlList,
    this.startDate,
    this.endDate,
    this.boostsMap,
  });

  AdvertisementModel copyWith({
    CategoryModel? category,
    String? name,
    String? title,
    String? shortDescription,
    String? description,
    int? fee,
    Gender? gender,
    List<String>? photoUrlList,
    DateTime? startDate,
    DateTime? endDate,
    Map<Boosts, DateTime>? boostsMap,
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
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      boostsMap: boostsMap ?? this.boostsMap,
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
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'boostsMap': boostsMap
          ?.map((key, value) => MapEntry(key.name, Timestamp.fromDate(value))),
    };
  }

  factory AdvertisementModel.fromMap(Map<String, dynamic> map) {
    return AdvertisementModel(
      category: map['category'] != null
          ? CategoryModel.fromMap(map['category'] as Map<String, dynamic>)
          : null,
      name: map['name'] as String,
      title: map['title'] as String,
      shortDescription: map['shortDescription'] as String,
      description: map['description'] as String,
      fee: map['fee'] as int,
      gender: map['gender'] != null
          ? Gender.values.firstWhere((element) => element.name == map['gender'])
          : null,
      photoUrlList: List<String>.from((map['photoUrlList'] as List<String>)),
      startDate: map['startDate'] != null
          ? (map['startDate'] as Timestamp).toDate()
          : null,
      endDate: map['endDate'] != null
          ? (map['endDate'] as Timestamp).toDate()
          : null,
      boostsMap: map['boostsMap'] != null
          ? (map['boostsMap'] as Map<String, Timestamp>).map((key, value) =>
              MapEntry(Boosts.values.firstWhere((e) => e.name == key),
                  value.toDate()))
          : null,
    );
  }
}
