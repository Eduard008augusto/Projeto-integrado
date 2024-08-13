// ignore_for_file: library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soft_shares/database/server.dart';
import 'package:soft_shares/database/var.dart' as globals;

class MultipleImagePickerPage extends StatefulWidget {
  const MultipleImagePickerPage({super.key});

  @override
  _MultipleImagePickerPageState createState() => _MultipleImagePickerPageState();
}

class _MultipleImagePickerPageState extends State<MultipleImagePickerPage> {
  List<File>? _selectedImages;

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolher Imagens'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_selectedImages != null && _selectedImages!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: _selectedImages!.map((image) {
                          return Image.file(image, width: 100, height: 100, fit: BoxFit.cover);
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImages,
                    child: const Text('Escolher outras imagens'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectedImages!.map((image) async {
                      await uploadImage(image);
                      await uploadImagemConteudo(2, 1, globals.imagem);
                    }).toList();
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}