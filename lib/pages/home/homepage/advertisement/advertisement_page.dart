import 'dart:io';

import 'package:f151/constants/constants.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AdvertisementPage extends StatefulWidget {
  final AdvertisementModel advertisement;
  final bool isAppBarOn;

  const AdvertisementPage(this.advertisement, this.isAppBarOn, {Key? key})
      : super(key: key);

  @override
  AdvertisementPageState createState() => AdvertisementPageState();
}

class AdvertisementPageState extends State<AdvertisementPage> {
  int currentImageIndex = 0;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
  }

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: widget.isAppBarOn
          ? AppBar(
              title: Text(widget.advertisement.title),
              centerTitle: true,
            )
          : null,
      body: Stack(
        children: [
          ListView(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: size.width,
                    width: size.width,
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.advertisement.photoUrlList.isNotEmpty
                          ? widget.advertisement.photoUrlList.length
                          : 1,
                      itemBuilder: (context, index) => widget
                              .advertisement.photoUrlList.isNotEmpty
                          ? Hero(
                              tag: widget.advertisement.photoUrlList[index],
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: widget.advertisement.photoUrlList[index]
                                        .contains('://')
                                    ? Image.network(
                                        widget
                                            .advertisement.photoUrlList[index],
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(widget
                                            .advertisement.photoUrlList[index]),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            )
                          : const ColoredBox(
                              color: Colors.grey,
                              child: Center(
                                child: Text('Bu ilanda fotograf bulunmuyor'),
                              ),
                            ),
                      onPageChanged: (value) {
                        setState(() => currentImageIndex = value);
                      },
                    ),
                  ),
                  widget.advertisement.photoUrlList.isEmpty
                      ? const SizedBox()
                      : Positioned(
                          right: 5,
                          left: 5,
                          top: 10,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black54,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  child: Text(
                                    '${currentImageIndex + 1}/${widget.advertisement.photoUrlList.length}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        )
                          .animate(delay: kDefaultAnimationDuration)
                          .fade(duration: kDefaultAnimationDuration)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.advertisement.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.advertisement.shortDescription,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.advertisement.description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ücret',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${widget.advertisement.fee} \$',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kategori',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.advertisement.category?.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cinsiyet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.advertisement.gender?.name ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(
                height: 45,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          onPressed: () => null,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Mesaj Gönder'),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.message)
                            ],
                          ))),
                  ElevatedButton(
                    onPressed: () => null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(45, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                    child: Icon(MdiIcons.heart, color: Colors.red),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
