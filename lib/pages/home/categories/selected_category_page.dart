import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/enums/category_enums.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/widgets/ad_list_card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SelectedCategoryPage extends StatelessWidget {
  final CategoryEnums categoryEnum;
  const SelectedCategoryPage({required this.categoryEnum, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(categoryEnum.name),
        actions: [
          IconButton(onPressed: () => null, icon: Icon(MdiIcons.dotsVertical))
        ],
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('ads')
              .where('category', isEqualTo: categoryEnum.name)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docs = snapshot.data!.docs;
              final dataMap = docs.map((e) => e.data()).toList();
              final adList =
                  dataMap.map((e) => AdvertisementModel.fromMap(e)).toList();
              return adList.isEmpty
                  ? const Center(
                      child: Text('Bu kategoride ilan bulunamadı'),
                    )
                  : ListView.builder(
                      itemCount: adList.length,
                      itemBuilder: (context, index) =>
                          AdListCard(advertisementModel: adList[index]),
                    );
            }
          }),
    );
  }
}
