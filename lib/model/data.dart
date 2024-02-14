class BossData {
  String id;
  String name;
  int resp;
  String coord;
  String? filePath;

  BossData(
      {required this.id,
      required this.coord,
      this.filePath,
      required this.name,
      required this.resp});

  factory BossData.fromMap(Map<String, dynamic> map) {
    return BossData(
      id: map['id'],
      name: map['name'],
      resp: map['resp'],
      coord: map['coord'],
      filePath: map['file_path'],
    );
  }
}

class BossTime {
  String id;
  DateTime killTime;
  BossTime({required this.id, required this.killTime});

  factory BossTime.fromMap(Map<String, dynamic> map) {
    return BossTime(
      id: map['id'],
      killTime: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }
}

class BossDataArr {
  late List<BossData> bossData;
  late List<BossTime> bossTime;
  BossDataArr({required this.bossData, required this.bossTime});
}
