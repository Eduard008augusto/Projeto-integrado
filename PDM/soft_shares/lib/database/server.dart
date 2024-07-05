// server.dart
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';

import 'var.dart' as globals;

var baseUrl = 'https://pintbackend-w8pt.onrender.com/';

Future<List<Map<String, dynamic>>> fetchAreas() async {
  final response = await http.get(Uri.parse('${baseUrl}area/listPorCentro/${globals.idCentro}'));
  var data = jsonDecode(response.body);
  if (data['success']) {
    List<Map<String, dynamic>> areas = List<Map<String, dynamic>>.from(data['data']);
    return areas;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<Map<String, dynamic>> login(String email, String password) async {
  final url = Uri.parse('${baseUrl}utilizador/loginApp');
  final body = json.encode({
    'EMAIL': email,
    'PASSWORD': password,
  });

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  var data = jsonDecode(response.body);

  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<void> uploadImage(File imageFile) async {
  var stream = http.ByteStream(imageFile.openRead().cast());
  var length = await imageFile.length();

  var uri = Uri.parse("${baseUrl}api/images");

  var request = http.MultipartRequest("POST", uri);
  var multipartFile = http.MultipartFile('image', stream, length, filename: basename(imageFile.path));

  request.fields['description'] = 'imagem';
  request.files.add(multipartFile);

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = await http.Response.fromStream(response);
    var responseData = json.decode(responseBody.body);
    globals.imagem = responseData['imageName'];
    print('Image uploaded: ${globals.imagem}');
  } else {
    print('Image upload failed');
  }
}

Future<Map<String, dynamic>> registo(var idcentro, var nome, var email, var password, var imagem) async {
  final url = Uri.parse('${baseUrl}utilizador/create');

  final body = json.encode({
    'ID_CENTRO': idcentro,
    'NOME': nome,
    'EMAIL': email,
    'PASSWORD': password,
    'IMAGEMPERFIL': imagem,
  });

  print('$idcentro + $nome + $email + $password');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  var data = jsonDecode(response.body);

  print(data.toString());

  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    print(res.toString());
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<List<Map<String, dynamic>>> fetchPublicacoes(var centro, var area, var subarea) async {
  final response = await http.get(Uri.parse('${baseUrl}conteudo/listPorCentroAreaSubArea/$centro/$area/$subarea'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> publicacoes = List<Map<String, dynamic>>.from(data['data']);
    return publicacoes;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<Map<String, dynamic>> fetchPublicacao(var id) async {
  final response = await http.get(Uri.parse('${baseUrl}conteudo/get/$id'));
  var data = jsonDecode(response.body);
  if(data['success']){
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<Map<String, dynamic>> fetchUtilizador(var id) async {
  final response = await http.get(Uri.parse('${baseUrl}utilizador/get/$id'));
  var data = jsonDecode(response.body);
  if(data['success']){
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}