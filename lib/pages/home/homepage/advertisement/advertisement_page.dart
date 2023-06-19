import 'dart:io';

import 'package:f151/models/advertisement_model.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
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
      body: ListView(
        children: [
          Stack(
            children: [
              SizedBox(
                height: size.width,
                width: size.width,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.advertisement.photoUrlList.isNotEmpty
                      ? widget.advertisement.photoUrlList.length
                      : 1,
                  itemBuilder: (context, index) =>
                      widget.advertisement.photoUrlList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(
                                File(widget.advertisement.photoUrlList![index]),
                                fit: BoxFit.cover,
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
                          widget.advertisement.category?.name ?? "",
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
                          widget.advertisement.gender?.name ?? "",
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
        ],
      ),
    );
  }
}
