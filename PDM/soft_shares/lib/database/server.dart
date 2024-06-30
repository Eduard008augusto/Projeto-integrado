// server.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

var baseUrl = 'https://pintbackend-w8pt.onrender.com/';
var localhost = 'http://localhost:3000/';

Future<List<Map<String, dynamic>>> fetchAreas() async {
  final response = await http.get(Uri.parse('${baseUrl}area/list'));  // area/listporcentro/idcentro
  var data = jsonDecode(response.body);
  if (data['success']) {
    // Certifique-se de que 'data' é uma lista de mapas.
    List<Map<String, dynamic>> areas = List<Map<String, dynamic>>.from(data['data']);
    return areas;
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

Future<Map<String, dynamic>> login(String email, String password) async {
  final url = Uri.parse('${baseUrl}utilizador/login');
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
