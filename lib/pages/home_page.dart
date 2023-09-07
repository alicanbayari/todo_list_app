import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_app/data/database.dart';

import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Hive boxa referans

  final _myBox = Hive.box('myBox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    //Eğer bu uyugulama ilk defa açılıyorsa kutuya veri ekle
    if (_myBox.get("YAPILACAKLAR") == null) {
      db.createInitialData();
      db.updateDataBase();
    } else {
      db.loadData();
    }

    super.initState();
  }

  //yapılacaklar listesinin listesi(database e taşındı)

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  //Yeni Görev ekleme

  void createNewTask() {
    String newTaskName = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.yellow[300],
          title: const Text("Yeni Görev Ekle"),
          content: TextField(
            onChanged: (value) {
              newTaskName = value;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  db.toDoList.add([newTaskName, false]);
                });
                Navigator.pop(context);
              },
              child: const Text("Ekle"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
              ),
            ),
          ],
        );
      },
    );
    db.updateDataBase();
  }

//Görev silme

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[300],
      appBar: AppBar(
        title: const Text('Yaqpılacaklar Listesi'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orange[700],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.orange[700],
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
