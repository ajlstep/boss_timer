import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sett {
  final String _settKey = 'alarm_int';
  final int _standart_minutes = 2;
  final getIt = GetIt.instance;
  late Duration _alaramPreDuration;
  Sett();

  Future<void> init() async {
    int? alarmInt = getIt<SharedPreferences>().getInt(_settKey);
    if (alarmInt != null) {
      _alaramPreDuration = Duration(minutes: alarmInt);
    } else {
      getIt<SharedPreferences>().setInt(_settKey, _standart_minutes);
      _alaramPreDuration = Duration(minutes: _standart_minutes);
    }
  }

  Duration get prealarm => _alaramPreDuration;
  set prealarmset(int value) {
    getIt<SharedPreferences>().setInt(_settKey, value);
    _alaramPreDuration = Duration(minutes: value);
  }
}
