// server.dart
// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:soft_shares/database/var.dart';

var baseUrl = 'https://pintbackend-w8pt.onrender.com/';

Future<List<Map<String, dynamic>>> fetchAreas() async {
  final response = await http.get(Uri.parse('${baseUrl}area/listPorCentro/$idCentro'));
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

Future<Map<String, dynamic>> registo(var idcentro, var nome, var desc, var morada, DateTime? dataNascimento, var telefone, var email, var password, var imagemperfil) async {
  final url = Uri.parse('${baseUrl}utilizador/create');
  final body = json.encode({
    'ID_CENTRO': idcentro,
    'NOME': nome,
    'DESCRICAO': desc,
    'MORADA': morada,
    'DATANASCIMENTO': dataNascimento,
    'DATAREGISTO': DateTime.now(),
    'TELEFONE': telefone,
    'EMAIL': email,
    'PASSWORD': password,
    'IMAGEMPERFIL': imagemperfil,
    'DATAULTIMA_ALTERACAO': DateTime.now(),
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