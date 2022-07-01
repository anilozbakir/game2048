import 'dart:async';

import "package:sqflite/sqflite.dart";

import 'package:path/path.dart';
import "dart:developer" as dv;
import "../model/game_data.dart";

class GameDataRep {
  GameDataRep() : super();
  Database? database;

  init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'timetable.db');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE GameData (matrix INTEGER PRIMARY KEY ,highScore INTEGER,lastGame TEXT )');
    });
    list().then((value) => {});
  }

  Future<int> add(GameParameters data) async {
    var id1 = 0;
    await database!.transaction((txn) async {
      id1 = await txn.rawInsert(
          'INSERT INTO GameData( highScore, lastGame ) VALUES(  "${data.highScore}" ,"${data.lastGame}"  )');
      dv.log('inserted1 to gameData table: $id1');
    });
    return id1;
  }

  updat(GameParameters data) async {
    int count = await database!.rawUpdate(
        'UPDATE GameData SET highScore = ?,lastGame = ? WHERE format = ?',
        [(data.highScore), (data.lastGame), data.format]);
  }

  delete(int format) async {
    var count = await database!
        .rawDelete('DELETE FROM GameData WHERE format = ?', ["$format  "]);
    assert(count == 1);
  }

  clearSimpleDateTable() async {}

  // Future<List<Map<String, dynamic>>> list() async {
  //   dv.log("listing");
  //   return database!.rawQuery('SELECT * FROM AlarmEvent');
  // }

  Future<List<GameParameters>> list() async {
    List<GameParameters> holiday = [];
    dv.log("listing");
    await database!
        .rawQuery('SELECT * FROM GameData')
        .onError((error, stackTrace) async {
      dv.log("error occured");
      await database!
          .execute(
              'CREATE TABLE GameData ( format INTEGER PRIMARY KEY,highScore INTEGER,lastGame TEXT )')
          .whenComplete(() => dv.log("created GameData table"));

      List<Map<String, dynamic>> newMap = [{}];
      return newMap;
    }).then((value) {
      holiday = List.generate(
          value.length, (index) => GameParameters.fromMap(value[index]));
    });
    return holiday;
  }

  Future<GameParameters> get(int format) async {
    GameParameters event = GameParameters.temp();
    await database!.rawQuery(
        'SELECT * FROM GameData WHERE format = ?', ["$format "]).then((value) {
      if (value.isNotEmpty) {
        event = GameParameters.fromMap(value.first);
      }
    });
    dv.log(
        "got from gameData   ${event.format}}  ${event.highScore}  ${event.lastGame}");
    return event;
  }
}
