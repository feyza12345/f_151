import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/enums/genders.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/models/category_model.dart';
import 'package:f151/pages/home/profile/create_advertisement/preview_advertisement_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicInformation extends StatefulWidget {
  final CategoryModel category;
  const BasicInformation(
    this.category, {
    super.key,
  });

  @override
  State<BasicInformation> createState() => _BasicInformationState();
}

class _BasicInformationState extends State<BasicInformation> {
  TextEditingController titleController = TextEditingController();
  TextEditingController shortDescriptionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  Gender? gender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temel Bilgiler'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'İlan Başlığı',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'İlan başlığı boş olamaz';
                } else if (value.length < 10) {
                  return 'İlan başlığı en az 10 karakter olmalıdır';
                }
                return null;
              },
            ),
            TextFormField(
              controller: shortDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Kısa Açıklama',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kısa Açıklama boş olamaz';
                } else if (value.length < 10) {
                  return 'Kısa Açıklama en az 10 karakter olmalıdır';
                }
                return null;
              },
              maxLength: 100,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
            ),
            TextFormField(
              controller: descriptionController,
              maxLines: null, // Bu satırı ekleyin
              decoration: const InputDecoration(
                labelText: 'Açıklama',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Açıklama boş olamaz';
                } else if (value.length < 10) {
                  return 'Açıklama en az 10 karakter olmalıdır';
                }
                return null;
              },
            ),
            TextFormField(
              controller: feeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  labelText: 'Ücret Bilgisi', prefix: Text('₺')),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ücret bilgisi boş olamaz';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Gender>(
              value: gender,
              items: Gender.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => gender = value!),
              hint: const Text('Cinsiyet Seçin'),
              validator: (value) {
                if (value == null) {
                  return 'Cinsiyet seçimi yapılmalıdır';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final advertisement = AdvertisementModel(
                  name: context.read<AppInfoBloc>().state.currentPerson.name,
                  title: titleController.text,
                  shortDescription: shortDescriptionController.text,
                  description: descriptionController.text,
                  category: widget.category,
                  gender: gender,
                  photoUrlList: [],
                  fee: int.parse(feeController.text));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PreviewAdvertisementPage(advertisement)));
            }
          },
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Devam Et'),
              SizedBox(
                width: 5,
              ),
              Icon(Icons.arrow_forward),
            ],
          )),
    );
  }
}
