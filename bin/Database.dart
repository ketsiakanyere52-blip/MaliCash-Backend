import 'package:mysql1/mysql1.dart';

class Database {
  static MySqlConnection? _connection;
  static Future<MySqlConnection> connect() async {
    if (_connection != null) return _connection!;

    var settings = ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      password: '1234',
      db: 'malicash',
    );
    _connection = await MySqlConnection.connect(settings);
    return _connection!;
  }
}
