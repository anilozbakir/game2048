import 'dart:async';

import "package:sqflite/sqflite.dart";

import 'package:path/path.dart';
import "dart:developer" as dv;
import "../model/game_data.dart";

class HolidayRep {
  HolidayRep() : super();
  Database? database;

  init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'timetable.db');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE GameData (id INTEGER PRIMARY KEY,matrix INTEGER,highScore INTEGER,lastGame TEXT )');
    });
    list().then((value) => {});
  }

  Future<int> add(GameParameters data) async {
    var id1 = 0;
    await database!.transaction((txn) async {
      id1 = await txn.rawInsert(
          'INSERT INTO GameData(  matrix, highScore, lastGame ) VALUES("${data.format}" , "${data.highScore}" ,"${data.lastGame}"  )');
      dv.log('inserted1 to gameData table: $id1');
    });
    return id1;
  }

  updat(GameParameters data) async {
    int count = await database!.rawUpdate(
        'UPDATE GameData SET matrix = ?, highScore = ?,lastGame = ? WHERE id = ?',
        [(data.format), (data.highScore), (data.lastGame), data.id]);
  }

  delete(int id) async {
    var count = await database!
        .rawDelete('DELETE FROM GameData WHERE id = ?', ["$id "]);
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
              'CREATE TABLE GameData (id INTEGER PRIMARY KEY,matrix INTEGER,highScore INTEGER,lastGame TEXT )')
          .whenComplete(() => dv.log("created GameData table"));

      List<Map<String, dynamic>> newMap = [{}];
      return newMap;
    }).then((value) {
      holiday = List.generate(
          value.length, (index) => GameParameters.fromMap(value[index]));
    });
    return holiday;
  }

  Future<GameParameters> get(int id) async {
    GameParameters event = GameParameters.temp();
    await database!
        .rawQuery('SELECT * FROM Holiday WHERE id = ?', ["$id "]).then((value) {
      if (value.isNotEmpty) {
        event = GameParameters.fromMap(value.first);
      }
    });
    dv.log(
        "get from holiday $id ${event.format}}  ${event.highScore}  ${event.lastGame}");
    return event;
  }
}
