import 'dart:ui';

import 'package:f151/components/custom_widgets.dart';
import 'package:f151/enums/category_enums.dart';
import 'package:f151/models/category_model.dart';
import 'package:f151/pages/home/categories/selected_category_page.dart';
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
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final lessonCategories = CategoryModel.lessonCategories;
    return Scaffold(
      appBar: CustomWidgets.appBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo/logo.png'),
        ),
        title: const Text('Kategoriler'),
        actions: [
          IconButton(onPressed: () => null, icon: Icon(MdiIcons.dotsVertical))
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: lessonCategories.length,
        itemBuilder: (context, index) {
          String category = lessonCategories.keys.elementAt(index);
          List<CategoryEnums> lessons = lessonCategories[category]!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 75,
                          width: double.infinity,
                          child: Image.asset(
                              'assets/images/categories/$category.jpg',
                              fit: BoxFit.fitWidth),
                        ),
                        Container(
                            height: 75,
                            width: double.infinity,
                            color:
                                isDarkMode ? Colors.black54 : Colors.white70),
                      ],
                    ),
                  ),
                  ExpansionTile(
                    tilePadding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: Align(
                      alignment: Alignment.center,
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            category,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                    ),
                    children: lessons
                        .map((lesson) => Column(
                              children: [
                                const Divider(
                                  height: 2,
                                ),
                                ListTile(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SelectedCategoryPage(
                                                  categoryEnum: lesson))),
                                  title: Center(child: Text(lesson.name)),
                                  trailing: const Icon(Icons.arrow_forward),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                ],
              ),
              const Divider(
                height: 2,
              ),
            ],
          );
        },
      ),
    );
  }
}
