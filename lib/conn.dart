import 'package:mysql1/mysql1.dart';

var mysqlconnector = MySqlConnection.connect(ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'igor',
    db: 'gpagri'));
