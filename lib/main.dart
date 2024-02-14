import 'dart:io';

import 'package:bos_timer/model/db_model.dart';
import 'package:bos_timer/service/db_service/supabase.dart';
import 'package:bos_timer/utils/read_json.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;

  var mapcon = await ReadJson.read('data/supabase.json');
  if (mapcon == null) {
    exit(1);
  }
  var dbconn = SupabaseConnection.fromMap(mapcon);
  var dbService = DBService.createService(0);
  await dbService.initialize(dbconn);
  getIt.registerSingleton<DBService>(dbService);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bos timer',
      home: const MyHomePage(title: 'bos timer'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(),
    );
  }
}
