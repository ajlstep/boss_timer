import 'package:bos_timer/model/data.dart';
import 'package:bos_timer/model/db_model.dart';
import 'package:bos_timer/model/error_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends DBService {
  late Supabase _instance;

  SupabaseService();

  @override
  get instance => _instance;

  @override
  Future<ErrorModel> initialize(DBConnection conn) async {
    await Supabase.initialize(
      url: conn.url,
      anonKey: conn.anonkey,
    );
    _instance = Supabase.instance;
    return ErrorModel(e: null);
  }

  @override
  Future<List<BossData>?> getBosData() async {
    List<BossData> data = [];
    try {
      List<dynamic> s = await _instance.client
          .from('boss')
          .select('id, name, resp, coord, file_path');
      data = s.map((el) {
        return BossData.fromMap(el);
      }).toList();
    } catch (e) {
      return null;
    }
    return data;
  }

  @override
  Future<List<BossTime>?> getBosTime() async {
    List<BossTime> data = [];
    try {
      List<dynamic> s =
          await _instance.client.from('timer').select('id, boss, time');
      data = s.map((el) {
        return BossTime.fromMap(el);
      }).toList();
    } catch (e) {
      return null;
    }
    return data;
  }
}

class SupabaseConnection extends DBConnection {
  @override
  String url;
  @override
  String anonkey;
  SupabaseConnection({required this.anonkey, required this.url})
      : super(anonkey: anonkey, url: url);

  bool get isEmpty => url == '';

  factory SupabaseConnection.fromMap(Map<String, dynamic> map) {
    return SupabaseConnection(
      url: map['url'], // Inițializați 'id' din map
      anonkey: map['anonkey'],
    );
  }

  factory SupabaseConnection.empty() {
    return SupabaseConnection(anonkey: '', url: '');
  }
}
