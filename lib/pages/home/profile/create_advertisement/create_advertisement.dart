import 'dart:ui';

import 'package:f151/components/custom_widgets.dart';
import 'package:f151/enums/category_enums.dart';
import 'package:f151/models/category_model.dart';
import 'package:f151/pages/home/profile/create_advertisement/basic_information.dart';
import 'package:flutter/material.dart';

class CreateAdvertisement extends StatelessWidget {
  const CreateAdvertisement({super.key});

  @override
  Widget build(BuildContext context) {
    final lessonCategories = CategoryModel.lessonCategories;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomWidgets.appBar(title: const Text('İlan Ver')),
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
                                              BasicInformation(lesson))),
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
