import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/components/custom_widgets.dart';
import 'package:f151/constants/constants.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/models/person_model.dart';
import 'package:f151/pages/home/chat/messages_page.dart';
import 'package:f151/pages/home/homepage/advertisement/reviews/reviews_page.dart';
import 'package:f151/pages/home/profile/create_advertisement/basic_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

class AdvertisementPage extends StatelessWidget {
  final AdvertisementModel advertisement;
  final bool isAppBarOn;

  AdvertisementPage(this.advertisement, this.isAppBarOn, {Key? key})
      : super(key: key);
  final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: isAppBarOn
          ? CustomWidgets.appBar(
              title: Text(advertisement.title),
            )
          : null,
      body: Stack(
        children: [
          ListView(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: size.width - 60,
                    width: size.width,
                    child: PageView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: advertisement.photoUrlList.isNotEmpty
                          ? advertisement.photoUrlList.length
                          : 1,
                      itemBuilder: (context, index) => advertisement
                              .photoUrlList.isNotEmpty
                          ? Hero(
                              tag: advertisement.photoUrlList[index],
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: advertisement.photoUrlList[index]
                                        .contains('://')
                                    ? Image.network(
                                        advertisement.photoUrlList[index],
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(advertisement.photoUrlList[index]),
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
                        pageIndex.value = value;
                      },
                    ),
                  ),
                  advertisement.photoUrlList.isEmpty
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
                                  child: ValueListenableBuilder<int>(
                                      valueListenable: pageIndex,
                                      builder: (context, value, child) {
                                        return Text(
                                          '${pageIndex.value + 1}/${advertisement.photoUrlList.length}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        );
                                      }),
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
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      advertisement.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        .animate(delay: 300.ms)
                        .moveX(
                          begin: -20,
                        )
                        .fade(),
                    Text(
                      advertisement.shortDescription,
                      maxLines: 5,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ).animate(delay: 400.ms).moveX(begin: -20).fade(),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(advertisement.userId)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .color!,
                                  highlightColor: kAppBarBackgroundColor2,
                                  child: Container(
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            );
                          } else {
                            final user =
                                PersonModel.fromMap(snapshot.data!.data()!);
                            return InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ReviewsPage(
                                            adModel: advertisement,
                                            adOwner: user,
                                          ))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              kAppBarBackgroundColor2,
                                          foregroundImage: user.imageUrl == null
                                              ? null
                                              : NetworkImage(user.imageUrl!),
                                          child: user.imageUrl != null
                                              ? null
                                              : const Icon(
                                                  Icons.person,
                                                  size: 25,
                                                  color: Colors.white,
                                                )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(user.name),
                                          Text(
                                            '${DateFormat('MMMM', 'tr_TR').format(user.createDate)} ${DateFormat('yyyy').format(user.createDate)}\'den beri üye',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Yorumlar',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          Icon(
                                            Icons.star_border,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                        }).animate(delay: 500.ms).moveX(begin: -20).fade(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider()
                        .animate(delay: 550.ms)
                        .moveX(begin: -20)
                        .fade(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ücret'),
                          Text(
                            '${advertisement.fee} ₺',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 600.ms).moveX(begin: -20).fade(),
                    const Divider()
                        .animate(delay: 650.ms)
                        .moveX(begin: -20)
                        .fade(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Kategori'),
                          Text(
                            advertisement.category?.name ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 700.ms).moveX(begin: -20).fade(),
                    const Divider()
                        .animate(delay: 750.ms)
                        .moveX(begin: -20)
                        .fade(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Cinsiyet'),
                          Text(
                            advertisement.gender?.name ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 800.ms).moveX(begin: -20).fade(),
                    const Divider()
                        .animate(delay: 850.ms)
                        .moveX(begin: -20)
                        .fade(),
                    const SizedBox(height: 20),
                    Text(
                      advertisement.description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ).animate(delay: 900.ms).moveX(begin: -20).fade(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(
                height: 45,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: advertisement.userId != currentUser?.uid
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (currentUser == null) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Giriş Yapılmadı'),
                                                content: const Text(
                                                    'Bir ilana mesaj göndermeden önce giriş yapmalısınız.'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                          ..pop()
                                                          ..pop();
                                                        context
                                                            .read<AppInfoBloc>()
                                                            .setPageIndex(3);
                                                      },
                                                      child: const Text(
                                                          'Giriş Yap')),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child:
                                                          const Text('İptal'))
                                                ],
                                              ));
                                    } else if (advertisement.userId ==
                                        currentUser.uid) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Kendinize mesaj gönderemezsiniz')));
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MessagesPage(
                                                      otherUserId:
                                                          advertisement.userId,
                                                      adId:
                                                          advertisement.adId)));
                                    }
                                  },
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
                          const SizedBox(
                            width: 10,
                          ),
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
                      ).animate(delay: 1100.ms).moveY(begin: 45).fade()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BasicInformation(
                                          advertisement.category!,
                                          advertisementModel: advertisement,
                                        ))),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(45, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(45),
                              ),
                            ),
                            child: Icon(MdiIcons.pencil, color: Colors.white),
                          )
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
