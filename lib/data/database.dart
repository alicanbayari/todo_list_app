import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];

  //kutuya referans
  final _mybox = Hive.box('myBox');

  void createInitialData() {
    toDoList = [
      ['Flutter Öğren', false],
      ['Flutter ile uygulama yap', false],
      ['Flutter ile para kazan', false],
    ];
  }

  //veriyi veri tabanından yükle

  void loadData() {
    toDoList = _mybox.get("YAPILACAKLAR") ?? [];
  }

  //veritabanını güncelle
  void updateDataBase() {
    _mybox.put("YAPILACAKLAR", toDoList);
  }
}
