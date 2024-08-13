import 'dart:io';
import 'package:flutter/material.dart';
import 'image_picker_page.dart'; 

void main() {
  runApp(const UploadImage());
}

class UploadImage extends StatelessWidget {
  const UploadImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UploadImagePage(),
    );
  }
}

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload de Imagem'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                File? pickedImage = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImagePickerPage(
                      onImagePicked: (File? pickedImage) {
                        setState(() {
                          image = pickedImage;
                        });
                      },
                    ),
                  ),
                );
                if (pickedImage != null) {
                  setState(() {
                    image = pickedImage;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 50,
                      color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Escolher Imagem',
                      style: TextStyle(
                        color: Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (image != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Image.file(
                          image!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                if (image != null) {
                  try {
                    await uploadImage(image!);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upload realizado com sucesso!')),
                    );
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao fazer upload: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nenhuma imagem selecionada.')),
                  );
                }
              },
              icon: const Icon(Icons.upload),
              label: const Text('Fazer Upload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage(File image) async {
  }
}
