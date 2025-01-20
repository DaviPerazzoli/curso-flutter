import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class TodoListState extends ChangeNotifier{
  final TodoDatabase _database = TodoDatabase.instance;
  List<TaskList> taskLists = [];
  TaskList? selectedTaskList;
  String? errorMessage;
  Function? lastCalledTaskSet;
  SortByOption selectedSortByOption = SortByOption.dueDate;
  bool reverseSort = false;

  Future<void> setAllTaskLists () async {
    try {
      taskLists = await _database.getAllTaskLists();
      log('All taskLists set!');
    } catch (e) {
      errorMessage = 'Failed to set all task lists: $e';
      log(errorMessage!);
    } finally {
      notifyListeners();
    }
  }

  Future<void> setAllTasks (int taskListId) async {
    try{
      selectedTaskList = await _database.getTaskList(taskListId);
      sortTasksBy(selectedSortByOption, reverseSort);
      log('All tasks set!');
    } catch (e) {
      errorMessage = 'Failed to load all tasks: $e';
      log(errorMessage!);
    } finally {
      lastCalledTaskSet = setAllTasks;
      notifyListeners();
    }
  }

  Future<void> addTask (Task task) async {
    try {
      int id = await _database.createTask(task);
      task.id = id;
      selectedTaskList!.add(task);
      log('Task with id ${task.id} added!');
    } catch (e) {
      errorMessage = 'Failed to add task: $e';
      log(errorMessage!);
    } finally {
      notifyListeners();
      lastCalledTaskSet?.call();
    }
  }

  Future<void> updateTask (Task task) async {
     try {
      int affectedRows = await _database.updateTask(task);
      
      if (affectedRows > 0) {
        int index = selectedTaskList!.tasks.indexWhere((element) => element.id == task.id);
        if (index != -1) {
          selectedTaskList!.tasks[index] = task;
          log('Updated task with id ${task.id}');
        } else {
          log('The updated task is not in the list');
        }
      }
      
    } catch (e) {
      errorMessage = 'Failed to update task: $e';
      log(errorMessage!);
    } finally {
      notifyListeners();
      lastCalledTaskSet?.call();
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      _database.deleteTask(id);
    } catch (e) {
      errorMessage = 'Failed to delete task: $e';
      log(errorMessage!);
    } finally {
      notifyListeners();
      lastCalledTaskSet?.call();
    }
  }

  Future<void> deleteAllTasks() async {
    try {
      _database.clearTasks();
      log('All tasks deleted!');
    } catch (e) {
      errorMessage = 'Failed to delete all tasks: $e';
      log(errorMessage!);
    } finally {
      notifyListeners();
      lastCalledTaskSet?.call();
    }
  }

  void sortTasksBy (SortByOption opt, bool reverse) {
    selectedSortByOption = opt;
    reverseSort = reverse;
    try {
      selectedTaskList!.sortBy(opt, reverse);
    } catch (e) {
      errorMessage = 'Failed to sort task list';
      log(errorMessage!);
    } finally {
      notifyListeners();
    }
  }
}