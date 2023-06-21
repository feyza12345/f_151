enum Boosts {
  onTop('Üst Sırada Göster',
      'İlanınızı arama sonuçlarında üst sıralarda gösterin.', 10),
  colorful('Renkli İlan',
      'İlanınıza renkli çerçeve ve vurgulu metin ekleyerek dikkat çekin.', 15),
  onHomepage('Anasayfada Göster',
      'İlanınızı uygulamanın ana sayfasında ön plana çıkarın.', 20),
  appAds('Uygulama Reklamları',
      'İlanınızı uygulama içindeki reklamlarla birlikte gösterin.', 25);

  final String title;
  final String description;
  final int feeForAWeek;

  const Boosts(this.title, this.description, this.feeForAWeek);
}
