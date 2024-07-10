import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  // Função para obter o token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Função para armazenar o token
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // Função para remover o token (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('idUtilizador');
    await prefs.remove('nomeUtilizador');
  }

  // Função para obter o idUtilizador
  Future<int?> getIdUtilizador() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idUtilizador');
  }

  // Função para armazenar o idUtilizador
  Future<void> storeIdUtilizador(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('idUtilizador', id);
  }

  // Função para obter o idUtilizador
  Future<String?> getNomeUtilizador() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nomeUtilizador');
  }

  // Função para armazenar o idUtilizador
  Future<void> storeNomeUtilizador(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nomeUtilizador', nome);
  }
}
