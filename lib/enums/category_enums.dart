enum CategoryEnums {
  english('İngilizce', 'assets/images/english.png'),
  german('Almanca', 'assets/images/german.png'),
  french('Fransızca', 'assets/images/french.png'),
  spanish('İspanyolca', 'assets/images/spanish.png'),
  paint('Resim', 'assets/images/paint.png'),
  musicTheory('Müzik Teorisi', 'assets/images/musicTheory.png'),
  piano('Piyano', 'assets/images/piano.png'),
  guitar('Gitar', 'assets/images/guitar.png'),
  photography('Fotoğrafçılık', 'assets/images/photography.png'),
  graphicDesign('Grafik Tasarımı', 'assets/images/graphicDesign.png'),
  fashionDesign('Moda Tasarımı', 'assets/images/fashionDesign.png'),
  programming('Programlama', 'assets/images/programming.png'),
  web('Web', 'assets/images/web.png'),
  mobile('Mobil Uygulama Geliştirme', 'assets/images/mobile.png'),
  ai('Yapay Zeka', 'assets/images/ai.png'),
  dataScience('Veri Bilimi', 'assets/images/dataScience.png'),
  blockchain('Blok Zinciri', 'assets/images/blockchain.png'),
  softwareTesting('Yazılım Testi', 'assets/images/softwareTesting.png'),
  finance('Finans', 'assets/images/finance.png'),
  marketing('Pazarlama', 'assets/images/marketing.png'),
  entrepreneurship('Girişimcilik', 'assets/images/entrepreneurship.png'),
  math('Matematik', 'assets/images/math.png'),
  physics('Fizik', 'assets/images/physics.png'),
  biology('Biyoloji', 'assets/images/biology.png'),
  history('Tarih', 'assets/images/history.png'),
  geography('Coğrafya', 'assets/images/geography.png'),
  chemistry('Kimya', 'assets/images/chemistry.png'),
  turkish('Türkçe', 'assets/images/turkish.png'),
  yoga('Yoga', 'assets/images/yoga.png'),
  dance('Dans', 'assets/images/dance.png'),
  cooking('Yemek Pişirme', 'assetsimages/cooking.png');

  final String name;
  final String photoPath;

  const CategoryEnums(this.name, this.photoPath);
}
