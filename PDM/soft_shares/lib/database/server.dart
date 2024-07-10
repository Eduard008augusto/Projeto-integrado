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

Future<Map<String, dynamic>> fetchEvento(var idEvento) async {
  final response = await http.get(Uri.parse('${baseUrl}evento/get/$idEvento'));
  var data = jsonDecode(response.body);
  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<Map<String, dynamic>> createEvento(var centro, var area, var user, var nome, var data, var localizacao, var telefone, var imagem, var descricao, var preco) async {
  final url = Uri.parse('${baseUrl}evento/create');

  final body = json.encode({
    'ID_CENTRO': centro,
    'ID_AREA': area,
    'ID_UTILIZADOR': user,
    'NOME': nome,
    'DATA': data.toIso8601String(),
    'LOCALIZACAO': localizacao,
    'TELEFONE': telefone,
    'IMAGEMEVENTO': imagem,
    'DESCRICAO': descricao,
  });

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  var responseData = jsonDecode(response.body);

  print(responseData);

  if (responseData['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(responseData['data']);
    return res;
  } else {
    throw Exception('Falha ao criar novo evento\n\n${responseData['error']}');
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

Future<List<Map<String, dynamic>>> fetchFavoritos(var id) async {
  final response = await http.get(Uri.parse('${baseUrl}favorito/listporutilizador/$id'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar favoritos');
  }
}

Future<Map<String, dynamic>> checkAvaliacao(var user, var conteudo) async {
  final response = await http.get(Uri.parse('${baseUrl}avaliacao/utilizadorAvaliou/$user/$conteudo'));
  final data = jsonDecode(response.body);
  print(data);
  if(data['success']){
    globals.idAvaliacao = data['ID_AVALIACAO'];
    return data;
  } else {
    throw Exception('Falha na verificação');
  }
}

Future<Map<String, dynamic>> createAvaliacao(var conteudo, var user, var estrelas, var preco) async {
  final url = Uri.parse('${baseUrl}avaliacao/create');

  final body = json.encode({
    'ID_CONTEUDO': conteudo,
    'ID_UTILIZADOR': user,
    'AVALIACAOGERAL': estrelas,
    'AVALIACAOPRECO': preco
  });

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 201) {
    try {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);

      if (data['success']) {
        return data;
      } else {
        throw Exception('Falha ao criar avaliação: ${data['message']}');
      }
    } catch (e) {
      throw Exception('Erro ao decodificar a resposta JSON: $e');
    }
  } else {
    throw Exception('Erro na solicitação: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> updateAvaliacao(var id, var conteudo, var user, var estrelas, var preco) async {
  final url = Uri.parse('${baseUrl}avaliacao/update/$id');

  final body = json.encode({
    'ID_CONTEUDO': conteudo,
    'ID_UTILIZADOR': user,
    'AVALIACAOGERAL': estrelas,
    'AVALIACAOPRECO': preco
  });

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  try {
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    print(data);

    if (data['success']) {
      print('Avaliado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao atualizar avaliação: ${data['message']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

Future<Map<String, dynamic>> checkInscricao(var user, var evento) async {
  final response = await http.get(Uri.parse('${baseUrl}inscricaoevento/isInscrito/$user/$evento'));
  final data = jsonDecode(response.body);
  print(data);
  if(data['success']){
    if(data['isInscrito']){
      globals.idEventoINSC = data['ID_INSCRICAO'];
    }
    return data;
  } else {
    throw Exception('Falha na verificação');
  }
}

Future<Map<String, dynamic>> createInscricao(var evento, var user) async {
  final url = Uri.parse('${baseUrl}inscricaoevento/create');

  final body = json.encode({
    'ID_EVENTO': evento,
    'ID_UTILIZADOR': user
  });

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 201) {
    try {
      var data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);

      if (data['success']) {
        return data;
      } else {
        throw Exception('Falha ao criar avaliação: ${data['message']}');
      }
    } catch (e) {
      throw Exception('Erro ao decodificar a resposta JSON: $e');
    }
  } else {
    throw Exception('Erro na solicitação: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> deleteInscricao(var id) async {
  final url = Uri.parse('${baseUrl}inscricaoevento/delete');

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

Future<List<Map<String, dynamic>>> fetchEventosInscritos(var user) async {
  final response = await http.get(Uri.parse('${baseUrl}inscricaoevento/inscricoes/$user'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar favoritos');
  }
}