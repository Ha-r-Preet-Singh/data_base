import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyDBHelper {
  var NOTE_TABLE = "note";
  var COLUMN_NOTE_ID = "note_id";
  var COLUMN_NOTE_TITLE = "title";
  var COLUMN_NOTE_DESC = "desc";

  Future<Database> openDB() async {
    //get Directory path
    var mDirectory = await getApplicationDocumentsDirectory();

    //created  the Path
    await mDirectory.create(recursive: true);

    var dbPath = "$mDirectory/notedb.db";

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        var createTableQuery =
            "create table $NOTE_TABLE ($COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text)";
        db.execute(createTableQuery);
      },
    );
  }

  //add data to database
  Future<bool> addNote(String title, String desc)async{
    var db = await openDB();

    var check = await db
        .insert(NOTE_TABLE, {COLUMN_NOTE_TITLE: title, COLUMN_NOTE_DESC: desc});
    return check > 0;
  }


  // fetch data from database
  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await openDB();

    List<Map<String, dynamic>> notes = await db.query(NOTE_TABLE);
    return notes;
  }

  // update data in database
  Future<bool> updateNote(int id,String title ,String desc)async{

    var db =await openDB();

    int check =await db.update(NOTE_TABLE, {COLUMN_NOTE_TITLE:title,COLUMN_NOTE_DESC:desc},where: "$COLUMN_NOTE_ID = $id");
    return check > 0;
  }

  //delete note
Future<bool> deleteNote(int id)async{
    var db = await openDB();


    int check = await db.delete(NOTE_TABLE,where: "$COLUMN_NOTE_ID = ?",whereArgs:["$id"]);
    return check>0;
}

}
