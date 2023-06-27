import 'package:f151/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    var lessonCategories = CategoryModel.lessonCategories;
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
        body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: lessonCategories.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(lessonCategories[index].name),
          ),
        ));
  }
}
