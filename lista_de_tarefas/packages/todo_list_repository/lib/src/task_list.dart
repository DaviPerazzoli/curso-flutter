import 'dart:ui';

import 'todo_model.dart';

class TaskList {
  final List<Task> _tasks;
  String name;
  int? _id;
  Color color;

  int? get id => _id;

  set id(int? id) {
    _id = id;
  }

  TaskList.fromExistent(
    this._tasks,
    {required int id,
    required this.name,
    required this.color}
  ): _id = id;

  factory TaskList.fromMap(Map<String, dynamic> map, List<Task> tasks) {    
    return TaskList.fromExistent(tasks, id: map["id"], name: map["name"], color: Color(map['color']));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': name,
      // ignore: deprecated_member_use
      'color': color.value
    };
  }

  // ignore: unnecessary_constructor_name
  TaskList.new({required this.name, required this.color, int? id}): _tasks = [], _id = id;

  void add(Task task) {
    if(!_tasks.contains(task)){
      _tasks.add(task);
    }
  }

  void sortBy (SortByOption opt, bool reverse) {
    int reverseNum = reverse? -1 : 1;
    switch (opt) {
      case SortByOption.dueDate:
        sortByDueDate(reverseNum);
        break;
      case SortByOption.creationDate:
        sortByCreationDate(reverseNum);
        break;
    }
  }

  void sortByCreationDate(int reverseNum) {
    _tasks.sort((Task t1, Task t2) {
      return t1.creationDate.compareTo(t2.creationDate)*reverseNum;
    });
  }

  void sortByDueDate(int reverseNum){
    _tasks.sort((Task t1, Task t2) {
      if (t1.dueDate == null && t2.dueDate == null) return 0;
      if (t1.dueDate == null) return -1*reverseNum;
      if (t2.dueDate == null) return 1*reverseNum;

      return t1.dueDate!.compareTo(t2.dueDate!)*reverseNum;
    });
  }

  List<Task> get tasks {
    return _tasks;
  }
}

enum SortByOption {
  dueDate,
  creationDate
}