import 'package:f151/components/custom_widgets.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/models/comment_model.dart';
import 'package:f151/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewsPage extends StatefulWidget {
  final AdvertisementModel adModel;
  final PersonModel adOwner;

  const ReviewsPage({required this.adOwner, required this.adModel, Key? key})
      : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController commentController = TextEditingController();
  var starRating = 5;
  final comments = [
    CommentModel(
        name: 'Beliz Şen',
        stars: 4,
        comment: 'Hoca dersleri zamanında yaptı.',
        dateTime: DateTime(2023, 06, 25)),
    CommentModel(
        name: 'Ali Özel',
        stars: 4,
        comment: 'Grup dersleri çok verimli geciyor.',
        dateTime: DateTime(2023, 06, 29)),
    CommentModel(
        name: 'Zehra Öz',
        stars: 5,
        comment: 'Birebir dersler grup derslerinden daha iyi.',
        dateTime: DateTime(2023, 07, 10))
  ];

  Future<void> addComment(String comment) async {
    // Yorum ekleme işlemleri + yıldızla puanlama sistemi
  }
  Widget buildStar(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          starRating = index + 1;
        });
      },
      child: Icon(
        Icons.star,
        size: 40,
        color: (index + 1) <= starRating ? Colors.amber : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appBar(title: const Text('Yorumlar')),
      body: Stack(
        children: [
          Stack(
            children: [
              ListView.separated(
                separatorBuilder: ((context, index) =>
                    const Divider(height: 10)),
                itemCount: comments.length + 1,
                itemBuilder: (context, index) {
                  if (index == comments.length) {
                    return const SizedBox();
                  }
                  final comment = comments[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ...List.generate(
                                            comment.stars,
                                            (index) => const Icon(
                                                  Icons.star,
                                                  size: 20,
                                                  color: Colors.orange,
                                                )),
                                        ...List.generate(
                                            5 - comment.stars,
                                            (index) => const Icon(
                                                  Icons.star_border,
                                                  size: 20,
                                                  color: Colors.orange,
                                                ))
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              DateFormat('dd MMMM yyyy', 'tr_TR')
                                  .format(comment.dateTime),
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(comment.comment),
                      ],
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
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
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
