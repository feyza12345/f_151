class CategoryModel {
  String name;
  String imageUrl;

  CategoryModel({
    required this.name,
    required this.imageUrl,
  });
  static List<CategoryModel> get lessonCategories => [
        CategoryModel(
            name: 'Lise ve Üniversite', imageUrl: 'assets/images/math.png'),
        CategoryModel(
            name: 'İlkokul ve Ortaokul', imageUrl: 'assets/images/math.png'),
        CategoryModel(name: 'Matematik', imageUrl: 'assets/images/math.png'),
        CategoryModel(name: 'Fizik', imageUrl: 'assets/images/physics.png'),
        CategoryModel(name: 'Biyoloji', imageUrl: 'assets/images/biology.png'),
        CategoryModel(name: 'Tarih', imageUrl: 'assets/images/history.png'),
        CategoryModel(
            name: 'Coğrafya', imageUrl: 'assets/images/geography.png'),
        CategoryModel(name: 'Kimya', imageUrl: 'assets/images/chemistry.png'),
        CategoryModel(name: 'İngilizce', imageUrl: 'assets/images/english.png'),
        CategoryModel(name: 'Almanca', imageUrl: 'assets/images/german.png'),
        CategoryModel(name: 'Fransızca', imageUrl: 'assets/images/french.png'),
        CategoryModel(
            name: 'İspanyolca', imageUrl: 'assets/images/spanish.png'),
        CategoryModel(name: 'Türkçe', imageUrl: 'assets/images/turkish.png'),
        CategoryModel(name: 'Müzik', imageUrl: 'assets/images/music.png'),
        CategoryModel(name: 'Piyano', imageUrl: 'assets/images/piano.png'),
        CategoryModel(name: 'Gitar', imageUrl: 'assets/images/guitar.png'),
        CategoryModel(name: 'Resim', imageUrl: 'assets/images/painting.png'),
        CategoryModel(name: 'Yoga', imageUrl: 'assets/images/yoga.png'),
        CategoryModel(name: 'Dans', imageUrl: 'assets/images/dance.png'),
        CategoryModel(
            name: 'Fotografi', imageUrl: 'assets/images/photography.png'),
        CategoryModel(
            name: 'Programlama', imageUrl: 'assets/images/programming.png'),
        CategoryModel(
            name: 'Web Geliştirme', imageUrl: 'assets/images/web.png'),
        CategoryModel(
            name: 'Mobil Uygulama Geliştirme',
            imageUrl: 'assets/images/mobile.png'),
        CategoryModel(name: 'Yapay Zeka', imageUrl: 'assets/images/ai.png'),
        CategoryModel(
            name: 'Veri Bilimi', imageUrl: 'assets/images/data_science.png'),
        CategoryModel(
            name: 'Blockchain', imageUrl: 'assets/images/blockchain.png'),
        CategoryModel(name: 'Finans', imageUrl: 'assets/images/finance.png'),
        CategoryModel(
            name: 'Pazarlama', imageUrl: 'assets/images/marketing.png'),
        CategoryModel(
            name: 'Girişimcilik',
            imageUrl: 'assets/images/entrepreneurship.png'),
        CategoryModel(
            name: 'Grafik Tasarım',
            imageUrl: 'assets/images/graphic_design.png'),
        CategoryModel(
            name: 'Moda Tasarımı',
            imageUrl: 'assets/images/fashion_design.png'),
        CategoryModel(
            name: 'Yemek Yapma', imageUrl: 'assets/images/cooking.png'),
        CategoryModel(
            name: 'Fotoğrafçılık', imageUrl: 'assets/images/photography.png'),
        CategoryModel(
            name: 'Dil Öğrenme',
            imageUrl: 'assets/images/language_learning.png'),
        CategoryModel(
            name: 'Yazılım Testi',
            imageUrl: 'assets/images/software_testing.png'),
        CategoryModel(
            name: 'Diğer', imageUrl: 'assets/images/software_testing.png'),
      ];
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
