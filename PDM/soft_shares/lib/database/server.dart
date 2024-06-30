// server.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

var url = 'https://pintbackend-w8pt.onrender.com/';
var localhost = 'http://localhost:3000/';

Future<List<Map<String, dynamic>>> fetchAreas() async {
  final response = await http.get(Uri.parse('${url}area/list'));
  var data = jsonDecode(response.body);
  if (data['success']) {
    // Certifique-se de que 'data' é uma lista de mapas.
    List<Map<String, dynamic>> areas = List<Map<String, dynamic>>.from(data['data']);
    return areas;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}