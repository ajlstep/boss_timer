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
  String boss;
  DateTime killTime;
  BossTime({required this.killTime, required this.boss});

  factory BossTime.fromMap(Map<String, dynamic> map) {
    return BossTime(
      boss: map['boss'],
      killTime: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  List<BossTime>? findLatestBossTimes(List<BossTime>? bossTimes) {
    if (bossTimes == null || bossTimes.isEmpty) {
      return null;
    }

    // Creează un map pentru a ține evidența celor mai recente timpuri pentru fiecare bos unic
    Map<String, DateTime> latestTimes = {};

    // Parcurge lista și actualizează timpul cel mai recent pentru fiecare bos unic
    for (var bossTime in bossTimes) {
      if (!latestTimes.containsKey(bossTime.boss) ||
          bossTime.killTime.isAfter(latestTimes[bossTime.boss]!)) {
        latestTimes[bossTime.boss] = bossTime.killTime;
      }
    }

    // Creează o listă de BossTime-uri pentru timpurile cele mai recente pentru fiecare bos unic
    List<BossTime> latestBossTimes = latestTimes.entries
        .map((entry) => BossTime(boss: entry.key, killTime: entry.value))
        .toList();

    return latestBossTimes;
  }
}

class BossDataArr {
  late List<BossData> bossData;
  late List<BossTime> bossTime;
  BossDataArr({required this.bossData, required this.bossTime});
}
