import 'package:dotenv/dotenv.dart';
import 'package:mysql_driver/mysql_driver.dart';

var env = DotEnv();

class Database {
  static final Database _instance = Database._internal();
  factory Database() => _instance;

  MySQLConnectionPool? _pool;
  MySQLConnectionPool get pool {
    if (_pool == null) {
      print('ERROR : Database non initialisé. Appelez d\'abord init()');
      throw Exception('Database not initialise');
    }
    return _pool!;
  }

  Database._internal();

  bool _dbInitialized = false;

  Future<void> init() async {
    env.load();
    if (_dbInitialized) return;

    _pool = MySQLConnectionPool(
      host: env['DB_HOST']!,
      port: int.parse(env['DB_PORT']!.toString()),
      userName: env['DB_USER']!,
      password: env['DB_PASSWORD'],
      databaseName: env['DB_NAME'],
      maxConnections: 10,
      secure: env['ENV'] == 'dev',
    );

    print(
      "${'-' * 15} INITIALISE ${_pool?.databaseName}, ${_pool?.allConnectionsQty} ${'-' * 15}",
    );

    _dbInitialized = true;
  }

  Future<void> close() async {
    if (_pool != null) {
      await _pool!.close();
      print("DB POOL CLOSED");
    }
  }
}
