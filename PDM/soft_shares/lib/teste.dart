// ignore_for_file: avoid_print, library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Importação necessária para o MediaType
import 'dart:convert';

class AddUtilizador extends StatefulWidget {
  const AddUtilizador({super.key});

  @override
  _AddUtilizadorState createState() => _AddUtilizadorState();
}

class _AddUtilizadorState extends State<AddUtilizador> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ativoController = TextEditingController();
  File? _selectedFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendSave() async {
    if (_selectedFile == null) {
      _showAlertDialog('Selecione uma foto!');
      return;
    } else if (_nomeController.text.isEmpty) {
      _showAlertDialog('Insira um nome!');
      return;
    } else if (_dataNascimentoController.text.isEmpty) {
      _showAlertDialog('Insira uma data de nascimento!');
      return;
    } else if (_emailController.text.isEmpty) {
      _showAlertDialog('Insira o email!');
      return;
    } else if (_passwordController.text.isEmpty) {
      _showAlertDialog('Insira uma password!');
      return;
    } else if (_ativoController.text.isEmpty) {
      _showAlertDialog('Selecione uma opção no campo Estado!');
      return;
    }

    var uri = Uri.parse('https://pintbackend-w8pt.onrender.com/api/images');
    var request = http.MultipartRequest('POST', uri)
      ..fields['description'] = _nomeController.text
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        _selectedFile!.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      var data = jsonDecode(responseData.body);
      print(data);
      // alert("Image uploaded successfully");

      // Após o upload da imagem, chama a API /utilizador/create
      var user = {
        "nome": _nomeController.text,
        "descricao": _descricaoController.text,
        "dataNascimento": _dataNascimentoController.text,
        "telefone": _telefoneController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "ativo": _ativoController.text == "true" ? true : false
      };

      var createResponse = await http.post(
        Uri.parse('https://pintbackend-w8pt.onrender.com/utilizador/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );

      if (createResponse.statusCode == 200) {
        _showAlertDialog('Utilizador criado com sucesso!');
      } else {
        _showAlertDialog('Erro ao criar utilizador');
      }
    } else {
      print('Erro ao fazer upload da imagem');
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Utilizador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _dataNascimentoController,
              decoration: const InputDecoration(labelText: 'Data de Nascimento'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _ativoController,
              decoration: const InputDecoration(labelText: 'Ativo'),
            ),
            const SizedBox(height: 10),
            _selectedFile == null
                ? const Text('Nenhuma imagem selecionada.')
                : Image.file(_selectedFile!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Selecionar Imagem'),
            ),
            ElevatedButton(
              onPressed: _sendSave,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
