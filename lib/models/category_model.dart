import 'package:f151/enums/category_enums.dart';

class CategoryModel {
  String name;
  String imageUrl;

  CategoryModel({
    required this.name,
    required this.imageUrl,
  });
  static Map<String, List<CategoryEnums>> get lessonCategories => {
        'Yabancı Dil': [
          CategoryEnums.english,
          CategoryEnums.german,
          CategoryEnums.french,
          CategoryEnums.spanish,
        ],
        'Sanat': [
          CategoryEnums.paint,
          CategoryEnums.musicTheory,
          CategoryEnums.piano,
          CategoryEnums.guitar,
          CategoryEnums.photography,
          CategoryEnums.graphicDesign,
          CategoryEnums.fashionDesign,
        ],
        'Bilgi Teknolojisi': [
          CategoryEnums.programming,
          CategoryEnums.web,
          CategoryEnums.mobile,
          CategoryEnums.ai,
          CategoryEnums.dataScience,
          CategoryEnums.blockchain,
          CategoryEnums.softwareTesting,
        ],
        'İş': [
          CategoryEnums.finance,
          CategoryEnums.marketing,
          CategoryEnums.entrepreneurship,
        ],
        'Okul Dersleri': [
          CategoryEnums.math,
          CategoryEnums.physics,
          CategoryEnums.biology,
          CategoryEnums.history,
          CategoryEnums.geography,
          CategoryEnums.chemistry,
          CategoryEnums.turkish,
        ],
        'Fiziksel Aktivite': [
          CategoryEnums.yoga,
          CategoryEnums.dance,
        ],
        'Diğer': [
          CategoryEnums.cooking,
        ]
      };

  CategoryModel copyWith({
    String? name,
    String? imageUrl,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
