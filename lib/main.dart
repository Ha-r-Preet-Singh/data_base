import 'package:database_intro_46/my_db_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   List<Map<String,dynamic>>  notes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();

  }


  void getNotes()async{
    notes =await MyDBHelper().fetchAllNotes();
    setState(() {

    });

    print(notes.length);
    print(notes.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Noted"),
      ),




      body: ListView.builder(
        itemCount: notes.length,

        itemBuilder: (ctx, index) {
          var currNote = notes[index];
        return InkWell(
          onTap: ()async{
            await MyDBHelper().updateNote(currNote["note_id"],"updated title","updated desc");
           notes = await MyDBHelper().fetchAllNotes();
            setState(() {

            });
          },
          child: ListTile(
            leading: Text("${index+1}"),
            title: Text("${notes[index]["title"]}"),
            subtitle: Text("${notes[index]["desc"]}"),
            trailing: InkWell(
              onTap: ()async{
               await MyDBHelper().deleteNote(currNote["note_id"]);
                notes = await MyDBHelper().fetchAllNotes();
               setState(() {

               });
              },
              child: Icon(Icons.delete,color: Colors.redAccent,),
            ),
          ),
        );
      },),


      floatingActionButton: FloatingActionButton(
        onPressed: ()async{

         await MyDBHelper().addNote("Flutter", "Sqflite to handle offline data in Flutter");
          notes = await MyDBHelper().fetchAllNotes();
          setState(() {

          });
        },
        child: Icon(Icons.add),
      ),

    );
  }
}

