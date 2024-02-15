import 'dart:io';

import 'package:bos_timer/model/data.dart';
import 'package:bos_timer/model/db_model.dart';
import 'package:bos_timer/model/sett.dart';
import 'package:bos_timer/service/db_service/supabase.dart';
import 'package:bos_timer/utils/read_json.dart';
import 'package:bos_timer/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;

  var mapcon = await ReadJson.read('data/supabase.conn');
  if (mapcon == null) {
    exit(1);
  }
  var dbconn = SupabaseConnection.fromMap(mapcon);
  var dbService = DBService.createService(0);
  await dbService.initialize(dbconn);
  getIt.registerSingleton<DBService>(dbService);

  var sp = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sp);

  var sett = Sett();
  await sett.init();
  getIt.registerSingleton<Sett>(sett);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'bos timer',
      home: MyHomePage(title: 'bos timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<BossData>? bossDataList;
  late List<BossTime> bossTimeList;
  var getIt = GetIt.instance;
  Future<void> getBossList() async {
    bossDataList = await getIt<DBService>().getBosData();
    bossTimeList = await getIt<DBService>().getBosTime() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: getBossList(), // Funcția care returnează un Future<String>
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Afișează un CircularProgressIndicator când se încarcă datele
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Afișează un mesaj de eroare dacă apare o eroare în timpul încărcării datelor
              return Text('Error: ${snapshot.error}');
            } else {
              // Afișează datele dacă încărcarea este completă
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisExtent: 215,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: bossDataList!.length,
                itemBuilder: (BuildContext context, int index) {
                  BossData bossData = bossDataList![index];
                  // BossTime? bossTime = bossTimeList
                  //     .firstWhere((element) => element.boss == bossData.id);
                  // Duration remainingTime =
                  //     calculateRemainingTime(bossTime, bossData);
                  // String timerText = formatDuration(remainingTime);
                  return BossDataWidget(
                      bossData: bossData, killTime: ,);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Duration calculateRemainingTime(BossTime bossTime, BossData bossData) {
    DateTime respawnTime =
        bossTime.killTime.add(Duration(minutes: bossData.resp));
    return respawnTime.difference(DateTime.now());
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
