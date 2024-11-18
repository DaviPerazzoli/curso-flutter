import 'task.dart';

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

  List<Task> get tasks {
    return _tasks;
  }
}