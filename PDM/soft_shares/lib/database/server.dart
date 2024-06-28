// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

var url = 'https://pintbackend-w8pt.onrender.com/';

Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('${url}centro/list'));
    var data = jsonDecode(response.body);
    if (data['success']) {
      return data;
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }