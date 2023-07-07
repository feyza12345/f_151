import 'package:f151/components/custom_widgets.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/models/person_model.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  final AdvertisementModel adModel;
  final PersonModel adOwner;
  final TextEditingController commentController = TextEditingController();

  ReviewsPage({required this.adOwner, required this.adModel, Key? key})
      : super(key: key);

  Future<void> addComment(String comment) async {
    // Yorum ekleme işlemleri
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appBar(title: const Text('Yorumlar')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Burada hiç yorum bulunamadı 🤷‍♂️'),
          SizedBox(height: 40),
          Text('Aşağıdaki bilgileri kullanarak bir sayfa tasarımı oluşturabilirsiniz'),
          Text('adModel ve adOwner field\'larını kullanarak bu sayfayı tasarlayabilirsiniz :)'),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Yorum Ekle'),
                  content: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Yorumunuzu buraya girin',
                    ),
                    maxLines: 3,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        final comment = commentController.text;
                        if (comment.isNotEmpty) {
                          addComment(comment);
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ekle'),
                    ),
                    TextButton(
                      onPressed: () {
                        commentController.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text('İptal'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Yorum Yap'),
          ),
        ],
      ),
    );
  }
}
