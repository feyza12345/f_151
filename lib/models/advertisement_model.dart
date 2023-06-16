import 'dart:convert';

import 'package:f151/enums/genders.dart';
import 'package:f151/enums/lesson_locations.dart';
import 'package:f151/models/category_model.dart';
import 'package:flutter/foundation.dart';

class AdvertisementModel {
  final CategoryModel? category;
  final String name;
  final String title;
  final String? imageUrl;
  final String shortDescription;
  final String description;
  final int fee;
  final Gender? gender;
  final double? lat;
  final double? lng;
  final LessonLocation? lessonLocation;
  final List<String>? photoUrlList;

  AdvertisementModel({
    this.category,
    required this.name,
    required this.title,
    this.imageUrl,
    required this.shortDescription,
    required this.description,
    required this.fee,
    this.gender,
    this.lat,
    this.lng,
    this.lessonLocation,
    this.photoUrlList,
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
    double? lat,
    double? lng,
    LessonLocation? lessonLocation,
    List<String>? photoUrlList,
  }) {
    return AdvertisementModel(
      category: category ?? this.category,
      name: name ?? this.name,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      fee: fee ?? this.fee,
      gender: gender ?? this.gender,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      lessonLocation: lessonLocation ?? this.lessonLocation,
      photoUrlList: photoUrlList ?? this.photoUrlList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category?.toMap(),
      'name': name,
      'title': title,
      'imageUrl': imageUrl,
      'shortDescription': shortDescription,
      'description': description,
      'fee': fee,
      'gender': gender?.name,
      'lat': lat,
      'lng': lng,
      'lessonLocation': lessonLocation?.name,
      'photoUrlList': photoUrlList,
    };
  }

  factory AdvertisementModel.fromMap(Map<String, dynamic> map) {
    return AdvertisementModel(
      category: CategoryModel.fromMap(map['category'] as Map<String, dynamic>),
      name: map['name'] as String,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      shortDescription: map['shortDescription'] as String,
      description: map['description'] as String,
      fee: map['fee'] as int,
      gender: map['gender'] != null
          ? Gender.values.firstWhere((element) => element.name == map['gender'])
          : null,
      lat: map['lat'] != null ? map['lat'] as double : null,
      lng: map['lng'] != null ? map['lng'] as double : null,
      lessonLocation: map['lessonLocation'] != null
          ? LessonLocation.values
              .firstWhere((element) => element.name == map['lessonLocation'])
          : null,
      photoUrlList: map['photoUrlList'] != null
          ? List<String>.from((map['photoUrlList'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdvertisementModel.fromJson(String source) =>
      AdvertisementModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdvertisementModel(category: $category, name: $name, title: $title, imageUrl: $imageUrl, shortDescription: $shortDescription, description: $description, fee: $fee, gender: $gender, lat: $lat, lng: $lng, lessonLocation: $lessonLocation, photoUrlList: $photoUrlList)';
  }

  @override
  bool operator ==(covariant AdvertisementModel other) {
    if (identical(this, other)) return true;

    return other.category == category &&
        other.name == name &&
        other.title == title &&
        other.imageUrl == imageUrl &&
        other.shortDescription == shortDescription &&
        other.description == description &&
        other.fee == fee &&
        other.gender == gender &&
        other.lat == lat &&
        other.lng == lng &&
        other.lessonLocation == lessonLocation &&
        listEquals(other.photoUrlList, photoUrlList);
  }

  @override
  int get hashCode {
    return category.hashCode ^
        name.hashCode ^
        title.hashCode ^
        imageUrl.hashCode ^
        shortDescription.hashCode ^
        description.hashCode ^
        fee.hashCode ^
        gender.hashCode ^
        lat.hashCode ^
        lng.hashCode ^
        lessonLocation.hashCode ^
        photoUrlList.hashCode;
  }
}
