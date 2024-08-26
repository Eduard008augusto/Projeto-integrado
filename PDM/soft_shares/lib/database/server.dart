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
  var data = jsonDecode(response.body);
  if (data['success']) {
    List<Map<String, dynamic>> areas = List<Map<String, dynamic>>.from(data['data']);
    return areas;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

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
    throw Exception('Falha ao criar novo utilizador\n\n${data['error']}');
  }
}

// receber publicações
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

// editar evento por rever
Future<Map<String, dynamic>> updateEvento(var idEvento, var area, var subarea, var nome, var data, var morada, var imagem, var telefone, var desc, var preco) async {
  final url = Uri.parse('${baseUrl}evento/updateMobile/$idEvento');

  final body = json.encode({
    'ID_AREA': area,
    'ID_SUBAREA': subarea,
    'NOME': nome,
    'DATA': data,
    'LOCALIZACAO': morada,
    'IMAGEMEVENTO': imagem,
    'TELEFONE': telefone,
    'DESCRICAO': desc,
    'PRECO': preco,
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
      throw Exception('Falha ao atualizar evento: ${data['error']}');
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
    throw Exception('Falha ao obter comentários: ${data['erro']}');
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

// apaga um comentário de um conteudo
Future<Map<String, dynamic>> deleteComentarioConteudo(var comentario) async {
  final url = Uri.parse('${baseUrl}comentarioconteudo/delete');

  final body = json.encode({
    'ID_COMENTARIO': comentario,
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
      print('Comentário apagado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao apagar comentário: ${data['erro']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// denunciar um comentário de um conteudo
Future<Map<String, dynamic>> denunciarComentarioConteudo(var comentario) async {
  final response = await http.post(Uri.parse('${baseUrl}comentarioconteudo/denunciar/$comentario'));
  var data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao denunciar comentário: ${data['error']}');
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
Future<List<Map<String, dynamic>>> getComentarioEvento(var comentario) async {
  final response = await http.get(Uri.parse('${baseUrl}comentarioevento/list/$comentario'));
  var data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao obter comentário: ${data['erro']}');
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

// apaga um comentário de um conteudo
Future<Map<String, dynamic>> deleteComentarioEvento(var comentario) async {
  final url = Uri.parse('${baseUrl}comentarioevento/delete');

  final body = json.encode({
    'ID_COMENTARIO': comentario,
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
      print('Comentário apagado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao apagar comentário: ${data['erro']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// denunciar um comentário de um evento
Future<Map<String, dynamic>> denunciarComentarioEvento(var comentario) async {
  final response = await http.post(Uri.parse('${baseUrl}comentarioevento/denunciar/$comentario'));
  var data = jsonDecode(response.body);
  print(data);
  if (data['success']) {
    Map<String, dynamic> res = Map<String, dynamic>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao denunciar comentário: ${data['error']}');
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

// retorna a quantidade de notifcações
Future<int> quantidadeNotificacoes(var centro, var user) async {
  final response = await http.get(Uri.parse('${baseUrl}notificacao/NumeroNotifCentroUser/$centro/$user'));
  var data = jsonDecode(response.body);
  //print(data);
  if (data['success']) {
    return data['NumeroNotificacoes'];
  } else {
    throw Exception('Falha ao obter quantidade de notificações: ${data['error']}');
  }
}

// retorna as notifcações
Future<List<Map<String, dynamic>>> getNotificacoes(var centro, var user) async {
  final response = await http.get(Uri.parse('${baseUrl}notificacao/ListPorCentroUser/$centro/$user'));
  var data = jsonDecode(response.body);
  print(data);
  if(data['success']){
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao obter notificações: ${data['error']}');
  }
}

// apaga as notificações de um user
Future<Map<String, dynamic>> deleteNotificacoes(var centro, var user) async {
  final response = await http.get(Uri.parse('${baseUrl}notificacao/delete/$centro/$user'));
  var data = jsonDecode(response.body);
  if(data['success']){
    print(data['message']);
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao apagar notifcações: ${data['error']}');
  }
}

// verificar se o comentário do conteudo tem like
Future<Map<String, dynamic>> isLikedConteudo(var user, var comentario) async {
  final response = await http.get(Uri.parse('${baseUrl}avaliacaocomentarioconteudo/utilizadorAvaliouComentario/$user/$comentario'));
  var data = jsonDecode(response.body);
  if(data['success']){
    print(data['message']);
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao verificar likes: ${data['error']}');
  }
}

// adicionar like ao comentário do conteudo
Future<Map<String, dynamic>> createLikeConteudo(var comentario, var user) async {
  final url = Uri.parse('${baseUrl}avaliacaocomentarioconteudo/likeComentarioAdd');

  final body = json.encode({
    'ID_COMENTARIO': comentario,
    'ID_UTILIZADOR': user,
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
      print('Like adicionado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao atualizar like: ${data['erro']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// remover like ao comentário do conteudo
Future<Map<String, dynamic>> deleteLikeConteudo(var like) async {
  final url = Uri.parse('${baseUrl}avaliacaocomentarioconteudo/likeComentarioDelete');

  final body = json.encode({
    'ID_LIKE': like,
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
      print('Like removido com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao atualizar like: ${data['message']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// verificar se o comentário do evento tem like
Future<Map<String, dynamic>> isLikedEvento(var user, var comentario) async {
  final response = await http.get(Uri.parse('${baseUrl}avaliacaocomentarioevento/utilizadorAvaliouComentario/$user/$comentario'));
  var data = jsonDecode(response.body);
  if(data['success']){
    print(data['message']);
    Map<String, dynamic> res = Map<String, dynamic>.from(data);
    return res;
  } else {
    throw Exception('Falha ao verificar likes: ${data['error']}');
  }
}

// adicionar like ao comentário do evento
Future<Map<String, dynamic>> createLikeEvento(var comentario, var user) async {
  final url = Uri.parse('${baseUrl}avaliacaocomentarioevento/likeComentarioAdd');

  final body = json.encode({
    'ID_COMENTARIO': comentario,
    'ID_UTILIZADOR': user,
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
      print('Like adicionado com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao atualizar like: ${data['erro']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// remover like ao comentário do evento
Future<Map<String, dynamic>> deleteLikeEvento(var like) async {
  final url = Uri.parse('${baseUrl}avaliacaocomentarioevento/likeComentarioDelete');

  final body = json.encode({
    'ID_LIKE': like,
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
      print('Like removido com sucesso!');
      return data;
    } else {
      throw Exception('Falha ao atualizar like: ${data['message']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// sacar de todas as areas
Future<List<Map<String, dynamic>>> getAreasPreferencias(var centro, var user) async {
  final response = await http.get(Uri.parse('${baseUrl}preferencias/ListAreasComPreferencias/$centro/$user'));
  var data = jsonDecode(response.body);
  if(data['success']){
    print(data['message']);
    List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(data['data']);
    return res;
  } else {
    throw Exception('Falha ao carregar areas preferenciais: ${data['error']}');
  }
}

// salvar preferencia
Future<Map<String, dynamic>> savePreferencia(var user, var centro, var area) async {
  final url = Uri.parse('${baseUrl}preferencias/guardarPreferencia');

  final body = json.encode({
    'ID_UTILIZADOR': user,
    'ID_CENTRO': centro,
    'ID_AREA': area,
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
      print('Prefencia salva com sucesso');
      return data;
    } else {
      throw Exception('Falha ao salvar preferencia: ${data['error']}');
    }
  } catch (e) {
    throw Exception('Erro ao decodificar a resposta JSON: $e');
  }
}

// apagar um preferencia
Future<Map<String, dynamic>> deletePreferencia(var user, var centro, var area) async {
  final url = Uri.parse('${baseUrl}preferencias/deletePreferencia');

  final body = json.encode({
    'ID_UTILIZADOR': user,
    'ID_CENTRO': centro,
    'ID_AREA': area,
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
      print('Prefencia apagada com sucesso');
      return data;
    } else {
      throw Exception('Falha ao salvar preferencia: ${data['error']}');
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
    throw Exception('Falha ao carregar dados');
  }
}