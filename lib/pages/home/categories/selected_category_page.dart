import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/models/category_model.dart';
import 'package:f151/widgets/ad_list_card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SelectedCategoryPage extends StatefulWidget {
  final CategoryModel categoryModel;
  const SelectedCategoryPage({required this.categoryModel, super.key});

  @override
  State<SelectedCategoryPage> createState() => _SelectedCategoryPageState();
}

class _SelectedCategoryPageState extends State<SelectedCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text('Kategoriler'),
        actions: [
          IconButton(onPressed: () => null, icon: Icon(MdiIcons.dotsVertical))
        ],
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('ads')
              .where('category', isEqualTo: widget.categoryModel.name)
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
                  ? Center(
                      child: const Text('Bu kategoride ilan bulunamadı'),
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
