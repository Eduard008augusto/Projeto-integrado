import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionTeste {
  Future<int> testConnection() async {
    final List<ConnectivityResult> connection = await Connectivity().checkConnectivity();

    if (connection.contains(ConnectivityResult.mobile)) {
      return 1;
    } else if (connection.contains(ConnectivityResult.wifi)) {
      return 1;
    } else {
      return 0;
    }
  }
}