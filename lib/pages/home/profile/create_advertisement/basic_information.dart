import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f151/bloc/ads_bloc.dart';
import 'package:f151/bloc/app_info_bloc.dart';
import 'package:f151/components/custom_widgets.dart';
import 'package:f151/components/dialogs/common_alert_dialogs.dart';
import 'package:f151/enums/category_enums.dart';
import 'package:f151/enums/genders.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/pages/home/homepage/advertisement/advertisement_page.dart';
import 'package:f151/pages/home/profile/create_advertisement/select_photo_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicInformation extends StatefulWidget {
  final CategoryEnums category;
  final AdvertisementModel? advertisementModel;
  const BasicInformation(
    this.category, {
    this.advertisementModel,
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
  AdvertisementModel? advertisement;
  Gender? gender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    advertisement = widget.advertisementModel;
    if (advertisement != null) {
      titleController.text = advertisement!.title;
      shortDescriptionController.text = advertisement!.shortDescription;
      descriptionController.text = advertisement!.description;
      feeController.text = advertisement!.fee.toString();
      gender = advertisement!.gender;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.appBar(
        title: Text(advertisement != null ? 'İlanı Düzenle' : 'Temel Bilgiler'),
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
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'İlan başlığı boş olamaz';
                } else if (value.length < 10) {
                  return 'İlan başlığı en az 10 karakter olmalıdır';
                }
                return null;
              },
              maxLength: 50,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
            ),
            TextFormField(
              controller: shortDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Kısa Açıklama',
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
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
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Açıklama boş olamaz';
                } else if (value.length < 10) {
                  return 'Açıklama en az 10 karakter olmalıdır';
                }
                return null;
              },
              maxLength: 200,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: feeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Ücret Bilgisi',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefix: Text('₺'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ücret bilgisi boş olamaz';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<Gender>(
                    value: gender,
                    items: Gender.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => gender = value!),
                    decoration: const InputDecoration(
                      labelText: 'Cinsiyet Seçin',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Cinsiyet seçimi yapılmalıdır';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (advertisement != null) {
                CommonAlertDialogs.loadingScreen(context: context);
                advertisement = advertisement!.copyWith(
                    title: titleController.text,
                    shortDescription: shortDescriptionController.text,
                    description: descriptionController.text,
                    category: widget.category,
                    gender: gender,
                    fee: int.parse(feeController.text));
                await FirebaseFirestore.instance
                    .collection('ads')
                    .doc(advertisement!.adId)
                    .set(advertisement!.toMap())
                    .then((value) => context
                        .read<AdsBloc>()
                        .refresh()
                        .then((value) => Navigator.of(context)
                          ..pop()
                          ..pop()
                          ..pop())
                        .then((value) => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdvertisementPage(advertisement!, true)))));
              } else {
                advertisement = AdvertisementModel(
                    adId: FirebaseFirestore.instance.collection('ads').doc().id,
                    name: context.read<AppInfoBloc>().state.currentPerson.name,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    title: titleController.text,
                    shortDescription: shortDescriptionController.text,
                    description: descriptionController.text,
                    category: widget.category,
                    gender: gender,
                    photoUrlList: [],
                    fee: int.parse(feeController.text));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SelectPhotoPage(advertisement!)));
              }
            }
          },
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(advertisement != null ? 'Kaydet' : 'Devam Et'),
              SizedBox(
                width: 5,
              ),
              Icon(Icons.arrow_forward),
            ],
          )),
    );
  }
}
