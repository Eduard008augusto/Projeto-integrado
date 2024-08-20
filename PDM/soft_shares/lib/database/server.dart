<<<<<<< Updated upstream
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';

import 'var.dart' as globals;

var baseUrl = 'https://pintbackend-w8pt.onrender.com/';

// receber áreas
Future<List<Map<String, dynamic>>> fetchAreas() async {
  final response = await http.get(Uri.parse('${baseUrl}area/listPorCentro/${globals.idCentro}'));
=======
// server.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:soft_shares/database/var.dart';

var baseUrl = 'https://pintbackend-w8pt.onrender.com/';

Future<List<Map<String, dynamic>>> fetchAreas() async {
  final response = await http.get(Uri.parse('${baseUrl}area/listPorCentro/$idCentro'));
>>>>>>> Stashed changes
  var data = jsonDecode(response.body);
  if (data['success']) {
    List<Map<String, dynamic>> areas = List<Map<String, dynamic>>.from(data['data']);
    return areas;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

<<<<<<< Updated upstream
// login
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

// enviar imagem
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

// registar um user
Future<Map<String, dynamic>> registo(var idcentro, var nome, var email, var password) async {
  final url = Uri.parse('${baseUrl}utilizador/createnew');

  final body = json.encode({
    'ID_CENTRO': idcentro,
    'NOME': nome,
=======
Future<Map<String, dynamic>> login(String email, String password) async {
  final url = Uri.parse('${baseUrl}utilizador/loginApp');
  final body = json.encode({
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
  print(data);

  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao criar novo utilizador\n\n${data['error']}');
  }
}

// receber publicações
=======
  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
// receber publicações
Future<Map<String, dynamic>> fetchPublicacao(var id) async {
  final response = await http.get(Uri.parse('${baseUrl}conteudo/get/$id'));
  var data = jsonDecode(response.body);
  if(data['success']){
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados: ${data['error_mobile']}');
  }
}

// receber publicação do user
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

// receber utilizador
=======
>>>>>>> Stashed changes
Future<Map<String, dynamic>> fetchUtilizador(var id) async {
  final response = await http.get(Uri.parse('${baseUrl}utilizador/get/$id'));
  var data = jsonDecode(response.body);
  if(data['success']){
<<<<<<< Updated upstream
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

// receber subarea
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

// Criar publicação
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

// Atualizar utilizador
Future<Map<String, dynamic>> updateUser(var id, var nome, var desc, var morada, DateTime dataNascimento, var telefone, var imagem) async {
  final url = Uri.parse('${baseUrl}utilizador/updateApp/$id');

  final body = json.encode({
    'NOME': nome,
    'DESCRICAO': desc,
    'MORADA': morada,
    'DATANASCIMENTO': dataNascimento.toIso8601String(),
    'TELEFONE': telefone,
    'IMAGEMPERFIL': imagem,
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

// Receber Eventos
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

// Receber evento especifico
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

// Criar evento
Future<Map<String, dynamic>> createEvento(var centro, var area, var subArea, var user, var nome, var data, var localizacao, var telefone, var imagem, var descricao, var preco) async {
  final url = Uri.parse('${baseUrl}evento/create');

  final body = json.encode({
    'ID_CENTRO': centro,
    'ID_AREA': area,
    'ID_SUBAREA': subArea,
    'ID_UTILIZADOR': user,
    'NOME': nome,
    'DATA': data.toIso8601String(),
    'LOCALIZACAO': localizacao,
    'TELEFONE': telefone,
    'IMAGEMEVENTO': imagem,
    'DESCRICAO': descricao,
    'PRECO': preco,
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

// receber os favoritos
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

// verificar uma avaliação
Future<Map<String, dynamic>> checkAvaliacao(var user, var conteudo) async {
  final response = await http.get(Uri.parse('${baseUrl}avaliacao/utilizadorAvaliou/$user/$conteudo'));
  final data = jsonDecode(response.body);
  print(data);
  if(data['success']){
    if(data['Avaliou']){
      globals.idAvaliacao = data['ID_AVALIACAO'];
    }
    return data;
  } else {
    throw Exception('Falha na verificação');
  }
}

// criar uma avaliação
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

// atualizar uma avaliação
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

// verificar o estado de inscrição
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

// inscrever em um evento
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


// remove uma inscrição
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

// retorna eventos inscritos
Future<List<Map<String, dynamic>>> fetchEventosInscritos(var user) async {
  final response = await http.get(Uri.parse('${baseUrl}inscricaoevento/inscricoes/$user'));
  var data = jsonDecode(response.body);
  if (data['success']) {
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data'].map((item) => item['evento']));
    return res;
  } else {
    throw Exception('Falha ao obter eventos');
  }
}

// retorna publicações do user por rever
Future<List<Map<String, dynamic>>> getConteudoRever(var user, var centro) async {
  final response = await http.get(Uri.parse('${baseUrl}conteudo/listReverCentroUser/$centro/$user'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados: ${data.error}');
  }
}

// retorna eventos do user por rever
Future<List<Map<String, dynamic>>> getEventoRever(var user, var centro) async {
  final response = await http.get(Uri.parse('${baseUrl}evento/listReverPorUtilizadorECentro/$centro/$user'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados: ${data.error}');
  }
}

// editar conteudo por rever
Future<Map<String, dynamic>> updateConteudo(var idConteudo, var area, var subarea, var nome, var morada, var horario, var telefone, var imagem, var website, var acessibilidade) async {
  final url = Uri.parse('${baseUrl}conteudo/updateMobile/$idConteudo');

  final body = json.encode({
    'ID_AREA': area,
    'ID_SUBAREA': subarea,
    'NOMECONTEUDO': nome,
    'MORADA': morada,
    'HORARIO': horario,
    'TELEFONE': telefone,
    'IMAGEMCONTEUDO': imagem,
    'WEBSITE': website,
    'ACESSIBILIDADE': acessibilidade,
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
      print('Atualizado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao atualizar conteudo: ${data['error']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// retornar o album do conteudo
Future<List<Map<String, dynamic>>> getAlbumConteudo(var conteudo) async {
  final response = await http.get(Uri.parse('${baseUrl}fotoconteudo/listporconteudo/$conteudo'));
  var data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao obter imagens: ${data['error']}');
  }
}

// upload de imagens para o album do conteudo
Future<Map<String, dynamic>> uploadImagemConteudo(var conteudo, var user, var imagem) async {
  final url = Uri.parse('${baseUrl}fotoconteudo/create');

  final body = json.encode({
    'ID_CONTEUDO': conteudo,
    'ID_UTILIZADOR': user,
    'DESCRICAO': " ",
    'LOCALIZACAO': " ",
    'IMAGEM': imagem,
    'VISIBILIDADE': 1,
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
      print('Imagem enviada com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao enviar imagem: ${data['error']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// retornar o album do evento
Future<List<Map<String, dynamic>>> getAlbumEvento(var evento) async {
  final response = await http.get(Uri.parse('${baseUrl}fotoevento/listporevento/$evento'));
  var data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao obter imagens: ${data['error']}');
  }
}

// upload de imagens para o album do evento
Future<Map<String, dynamic>> uploadImagemEvento(var evento, var user, var imagem) async {
  final url = Uri.parse('${baseUrl}fotoevento/create');

  final body = json.encode({
    'ID_EVENTO': evento,
    'ID_UTILIZADOR': user,
    'DESCRICAO': " ",
    'LOCALIZACAO': " ",
    'IMAGEM': imagem,
    'VISIBILIDADE': 1,
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
      print('Imagem enviada com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao enviar imagem: ${data['error']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// retorna os comentários do conteudo
Future<List<Map<String, dynamic>>> getComentarioConteudo(var conteudo) async {
  final response = await http.get(Uri.parse('${baseUrl}comentarioconteudo/list/$conteudo'));
  var data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao obter imagens: ${data['erro']}');
  }
}

// cria os comentários do conteudo
Future<Map<String, dynamic>> createComentarioConteudo(var centro, var conteudo, var user, var comentario) async {
  final url = Uri.parse('${baseUrl}comentarioconteudo/create');

  final body = json.encode({
    'ID_CENTRO': centro,
    'ID_CONTEUDO': conteudo,
    'ID_UTILIZADOR': user,
    'COMENTARIO': comentario,
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
      print('Comentário criado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao criar comentário: ${data['erro']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// denunciar um comentário de um conteudo
Future<Map<String, dynamic>> denunciarComentarioConteudo(var conteudo) async {
  final response = await http.post(Uri.parse('${baseUrl}comentarioconteudo/denunciar/$conteudo'));
  var data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao obter imagens: ${data['error']}');
  }
}

// update comentário de um evento
Future<Map<String, dynamic>> updateComentarioConteudo(var comentario, var texto) async {
  final url = Uri.parse('${baseUrl}comentarioconteudo/update/$comentario');

  final body = json.encode({
    'COMENTARIO': texto,
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
      print('Comentário atualizado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao atualizar comentário: ${data['erro']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// retorna os comentários do evento
Future<List<Map<String, dynamic>>> getComentarioEvento(var evento) async {
  final response = await http.get(Uri.parse('${baseUrl}comentarioevento/list/$evento'));
  var data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao obter imagens: ${data['erro']}');
  }
}

// cria os comentários do evento
Future<Map<String, dynamic>> createComentarioEvento(var centro, var evento, var user, var comentario) async {
  final url = Uri.parse('${baseUrl}comentarioevento/create');

  final body = json.encode({
    'ID_CENTRO': centro,
    'ID_EVENTO': evento,
    'ID_UTILIZADOR': user,
    'COMENTARIO': comentario,
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
      print('Comentário criado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao criar comentário: ${data['erro']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// denunciar um comentário de um evento
Future<Map<String, dynamic>> denunciarComentarioEvento(var evento) async {
  final response = await http.post(Uri.parse('${baseUrl}comentarioevento/denunciar/$evento'));
  var data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao obter imagens: ${data['error']}');
  }
}

// update comentário de um evento
Future<Map<String, dynamic>> updateComentarioEvento(var comentario, var texto) async {
  final url = Uri.parse('${baseUrl}comentarioevento/update/$comentario');

  final body = json.encode({
    'COMENTARIO': texto,
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
      print('Comentário atualizado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao atualizar comentário: ${data['erro']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}





























//retorna os centros
Future<List<Map<String, dynamic>>> getCentros() async{
  final response = await http.get(Uri.parse('${baseUrl}centro/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna os utilizadores
Future<List<Map<String, dynamic>>> getUtilizadores() async{
  final response = await http.get(Uri.parse('${baseUrl}utilizador/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna os administradores
Future<List<Map<String, dynamic>>> getAdmins() async{
  final response = await http.get(Uri.parse('${baseUrl}administrador/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna as areas
Future<List<Map<String, dynamic>>> getAreas() async{
  final response = await http.get(Uri.parse('${baseUrl}area/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna as subareas
Future<List<Map<String, dynamic>>> getSubAreas() async{
  final response = await http.get(Uri.parse('${baseUrl}subArea/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna os conteudos
Future<List<Map<String, dynamic>>> getConteudos() async{
  final response = await http.get(Uri.parse('${baseUrl}conteudo/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna as avaliacoes
Future<List<Map<String, dynamic>>> getAvaliacoes() async{
  final response = await http.get(Uri.parse('${baseUrl}avaliacao/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna os eventos
Future<List<Map<String, dynamic>>> getEventos() async{
  final response = await http.get(Uri.parse('${baseUrl}evento/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna os favoritos
Future<List<Map<String, dynamic>>> getFavoritos() async{
  final response = await http.get(Uri.parse('${baseUrl}favorito/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna as fotografias_conteudo
Future<List<Map<String, dynamic>>> getFotografiasConteudo() async{
  final response = await http.get(Uri.parse('${baseUrl}fotoconteudo/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna as fotografias_eventos
Future<List<Map<String, dynamic>>> getFotografiasEventos() async{
  final response = await http.get(Uri.parse('${baseUrl}fotoevento/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

//retorna as inscrições eventos
Future<List<Map<String, dynamic>>> getInscricoesEventos() async {
  final response = await http.get(Uri.parse('${baseUrl}inscricaoevento/list'));
  var data = jsonDecode(response.body);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
=======
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
>>>>>>> Stashed changes
    throw Exception('Falha ao carregar dados');
  }
}