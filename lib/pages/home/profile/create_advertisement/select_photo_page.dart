import 'package:f151/components/custom_widgets.dart';
import 'package:f151/models/advertisement_model.dart';
import 'package:f151/pages/home/profile/create_advertisement/select_boost_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';

class SelectPhotoPage extends StatefulWidget {
  final AdvertisementModel advertisement;
  const SelectPhotoPage(this.advertisement, {super.key});

  @override
  State<SelectPhotoPage> createState() => _SelectPhotoPageState();
}

class _SelectPhotoPageState extends State<SelectPhotoPage> {
  List<Uint8List> selectedPhotosData = [];
  int count = 0;

  pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final data = await image.readAsBytes();
    setState(() {
      selectedPhotosData.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Offset calculateOffset(int index) {
      bool isAdding = count <= selectedPhotosData.length;
      count = selectedPhotosData.length;
      final objectSize = (size.width / 2);
      if (index == 5 && !isAdding) return const Offset(0, 0);
      if (index == 0) {
        return isAdding ? const Offset(0, 0) : Offset(objectSize, 0);
      }
      if (index.isOdd) {
        return isAdding
            ? Offset(-objectSize, 0)
            : Offset(-objectSize, objectSize);
      }
      if (index.isEven) {
        return isAdding
            ? Offset(objectSize, -objectSize)
            : Offset(objectSize, 0);
      }
      return const Offset(0, 0);
    }

    return Scaffold(
      appBar: CustomWidgets.appBar(
        title: const Text('İlan Fotoğraflarını Seç'),
      ),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: selectedPhotosData.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == selectedPhotosData.length) {
            if (selectedPhotosData.length != 6) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                    onPressed: () => pickImage(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add),
                        const Text('Fotoğraf Ekle'),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('${selectedPhotosData.length}/6'),
                      ],
                    )),
              ).animate().move(
                  begin: calculateOffset(index),
                  curve: const ElasticOutCurve(0.4),
                  duration: 800.ms);
            }
          } else {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        selectedPhotosData[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() =>
                          selectedPhotosData.remove(selectedPhotosData[index])),
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.remove_circle,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(''),
                  )
                ],
              ),
            ).animate().fade(delay: kThemeAnimationDuration);
          }
          return null;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SelectBoostPage(widget.advertisement, selectedPhotosData))),
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Devam'),
            SizedBox(
              width: 5,
            ),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
