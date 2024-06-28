// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class Servidor {
  var url = 'https://api.restful-api.dev/objects';
  
  Future<void> envio(titulo) async {
    var response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "name": titulo,
      }),
    );  
  print(response.body);
  }
}