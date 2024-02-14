import 'package:bos_timer/model/data.dart';
import 'package:bos_timer/model/error_model.dart';
import 'package:bos_timer/service/db_service/supabase.dart';

abstract class DBService {
  dynamic instance;

  DBService();
  static DBService createService(int typeService) {
    return baseTypes[typeService]();
  }

  //auth / reg
  Future<ErrorModel> initialize(DBConnection conn);
  Future<List<BossData>?> getBosData();
  Future<List<BossTime>?> getBosTime();
}

abstract class DBConnection {
  String url;
  String anonkey;
  DBConnection({required this.anonkey, required this.url});
}

var baseTypes = [
  () => SupabaseService(),
];
