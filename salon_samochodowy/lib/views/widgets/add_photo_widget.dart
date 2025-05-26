import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPhotoWidget extends StatefulWidget {
  final Function(String) onImageSelected; // Callback z wybraną ścieżką

  const AddPhotoWidget({super.key, required this.onImageSelected});

  @override
  _AddPhotoWidgetState createState() => _AddPhotoWidgetState();
}

class _AddPhotoWidgetState extends State<AddPhotoWidget> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImageSelected(pickedFile.path); // Zwróć ścieżkę pliku do rodzica
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 190,
            height: 170,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: _image == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 50, color: Colors.black54),
                SizedBox(height: 10),
                Text('Dodaj zdjęcie', style: TextStyle(color: Colors.black54)),
              ],
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _image!,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
