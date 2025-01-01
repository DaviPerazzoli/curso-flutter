import 'todo_model.dart';

class TaskList {
  final List<Task> _tasks;

  TaskList(
    this._tasks,
  );

  TaskList.empty(): _tasks = [];

  void add(Task task) {
    if(!_tasks.contains(task)){
      _tasks.add(task);
    }
  }

  void sortByDueDate(){
    _tasks.sort((Task t1, Task t2) {
      if (t1.dueDate == null && t2.dueDate == null) return 0;
      if (t1.dueDate == null) return -1;
      if (t2.dueDate == null) return 1;

      return t1.dueDate!.compareTo(t2.dueDate!);
    });
  }

  List<Task> get tasks {
    sortByDueDate();
    return _tasks;
  }
}