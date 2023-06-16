import 'package:f151/models/category_model.dart';
import 'package:f151/pages/home/profile/create_advertisement/basic_information.dart';
import 'package:flutter/material.dart';

class CreateAdvertisement extends StatelessWidget {
  const CreateAdvertisement({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CategoryModel.lessonCategories;
    return Scaffold(
      appBar: AppBar(title: const Text('İlan Ver')),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(height: 0),
          itemCount: categories.length,
          itemBuilder: (context, index) => ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BasicInformation(categories[index]))),
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text(categories[index].name),
              )),
    );
  }
}
