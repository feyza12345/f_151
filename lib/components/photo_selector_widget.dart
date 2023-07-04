import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PhotoSelectorWidget {
  static Future<XFile?> selectPhotoDialog(BuildContext context) async =>
      showModalBottomSheet<XFile?>(
          context: context,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(MdiIcons.camera),
                    onPressed: () => selectFromCamera
                        .then((value) => Navigator.pop(context, value)),
                    label: const Text('Kamera'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(MdiIcons.image),
                    onPressed: () => selectFromGallery.then((value) =>
                        Navigator.pop(context, value)) // Bottom sheet'i kapat
                    ,
                    label: const Text('Galeri'),
                  ),
                ],
              ),
            );
          });

  static Future<XFile?> get selectFromGallery =>
      ImagePicker().pickImage(source: ImageSource.gallery);
  static Future<XFile?> get selectFromCamera =>
      ImagePicker().pickImage(source: ImageSource.camera);
}
