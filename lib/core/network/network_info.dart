import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImp implements NetworkInfo {
  late final DataConnectionChecker connectionChecker;
  NetworkInfoImp(this.connectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => throw UnimplementedError();
}
