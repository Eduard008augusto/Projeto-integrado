// ignore_for_file: avoid_print

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';

import 'var.dart' as globals;

var baseUrl = 'https://pintbackend-w8pt.onrender.com/';
var localhost = 'http://localhost:3000/';

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
  try {
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

    print(data);

    if (data['success']) {
      Map<String, dynamic> res = Map<String, dynamic>.from(data);
      return res;
    } else {
      throw Exception('Email ou palavra-passe incorreto!');
    }
  } catch (e) {
    throw Exception('LOGIN ERROR: ${e.toString()}');
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
    print(responseData);
    globals.imagem = responseData['imageName'];
    print('Image uploaded: ${globals.imagem}');
  } else {
    print('Image upload failed');
  }
}

Future<Map<String, dynamic>> registo(var idcentro, var nome, var email, var password) async {
  final url = Uri.parse('${baseUrl}utilizador/createnew');

  final body = json.encode({
    'ID_CENTRO': idcentro,
    'NOME': nome,
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

  print(data);

  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao criar novo utilizador \n\n${data['error']}');
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
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<List<Map<String, dynamic>>> fetchPublicacaoUser(var id) async {
  final response = await http.get(Uri.parse('${baseUrl}conteudo/listPorUtilizador/$id'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<Map<String, dynamic>> fetchUtilizador(var id) async {
  final response = await http.get(Uri.parse('${baseUrl}utilizador/get/$id'));
  var data = jsonDecode(response.body);
  if(data['success']){
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<List<Map<String, dynamic>>> fetchSubAreas(var area) async {
  final response = await http.get(Uri.parse('${baseUrl}subArea/listPorArea/$area'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<Map<String, dynamic>> createPublicacao(var centro, var area, var subarea, var user, var nome, var morada, var horario, var telefone, var imagem, var website, var acessibilidade) async {
  final url = Uri.parse('${baseUrl}conteudo/create');

  final body = json.encode({
    'ID_CENTRO': centro,
    'ID_AREA': area,
    'ID_SUBAREA': subarea,
    'ID_UTILIZADOR': user,
    'NOMECONTEUDO': nome,
    'MORADA': morada,
    'HORARIO': horario,
    'TELEFONE': telefone,
    'IMAGEMCONTEUDO': imagem,
    'WEBSITE': website,
    'ACESSIBILIDADE': acessibilidade
  });

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  var data = jsonDecode(response.body);

  print(data);

  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao criar nova publicação\n\n${data['error']}');
  }
}

Future<Map<String, dynamic>> updateUser(var id, var nome, var desc, var morada, DateTime dataNascimento, var telefone, var imagem) async {
  final url = Uri.parse('${baseUrl}utilizador/updateApp/$id');

  final body = json.encode({
    'NOME': nome,
    'DESCRICAO': desc,
    'MORADA': morada,
    'DATANASCIMENTO': dataNascimento.toIso8601String(),
    'TELEFONE': telefone,
    'IMAGEM': imagem,
  });

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  var data = jsonDecode(response.body);

  if(data['success']){
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao atualizar utilizador!\n\n${data['error']}');
  }
}

// Fetch Eventos
Future<List<Map<String, dynamic>>> fetchEventos(int idCentro) async {
  final response = await http.get(Uri.parse('${baseUrl}evento/listPorCentro/$idCentro'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> eventos = List<Map<String, dynamic>>.from(data['data']);
    return eventos;
  } else {
    throw Exception('Falha ao carregar eventos');
  }
}

// ESTADO FAVORITO
Future<Map<String, dynamic>> isFavorito(var idUser, var idConteudo) async {
  final response = await http.get(Uri.parse('${baseUrl}favorito/isfavorito/$idUser/$idConteudo'));
  var data = jsonDecode(response.body);
  if(data['success']){
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao verificar favorito');
  }
}

// FAVORITO
Future<Map<String, dynamic>> createFavorito(var centro, var area, var subarea, var conteudo, var utilizador) async {
  final url = Uri.parse('${baseUrl}favorito/create');

  final body = json.encode({
    'ID_CENTRO': centro,
    'ID_AREA': area,
    'ID_SUBAREA': subarea,
    'ID_CONTEUDO': conteudo,
    'ID_UTILIZADOR': utilizador,
  });

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  var data = jsonDecode(response.body);

  print(data);

  if(data['success']){
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao criar favorito');
  }
}

// NÃO FAVORITO
Future<Map<String, dynamic>> deleteFavorito(var id) async {
  final url = Uri.parse('${baseUrl}favorito/delete');

  final body = json.encode({'id': id});

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 200) {
    try {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);

      if (data['success']) {
        return data;
      } else {
        throw Exception('Falha ao eliminar favorito: ${data['message']}');
      }
    } catch (e) {
      throw Exception('Erro ao decodificar a resposta JSON: $e');
    }
  } else {
    throw Exception('Erro na solicitação: ${response.statusCode}');
  }
}