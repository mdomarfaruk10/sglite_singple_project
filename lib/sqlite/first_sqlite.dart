import 'package:sqflite/sqflite.dart' as sqlite;
class SQLiteHealper{
  static Future<sqlite.Database> db()async{
    return sqlite.openDatabase(
      "info.db",
      version: 1,
      onCreate:(sqlite.Database database,int version){
        database.execute("CREATE TABLE note(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,title TEXT,description TEXT)");
    }
    );
  }
  static Future<int> insertData(String title,String description)async{
    final db=await SQLiteHealper.db();
    var values={
      "title":title,
      "description":description,
    };
    return db.insert("note", values);
  }
  static Future<List<Map<String,dynamic>>> getAlldata()async{
    final db=await SQLiteHealper.db();
    return db.query("note",orderBy: "id");

  }


  static Future<int> updatetData(int id,String title,String description)async{
    final db=await SQLiteHealper.db();
    var values={
      "title":title,
      "description":description,
    };
    return db.update("note", values,where: "id = ?",whereArgs:[id]);
  }

  static Future<int> deletData(int id)async{
    final db=await SQLiteHealper.db();
    return db.delete("note",where: "id = ?",whereArgs:[id]);
  }

}