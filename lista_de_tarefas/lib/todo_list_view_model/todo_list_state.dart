import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class TodoListState extends ChangeNotifier{
  final TodoDatabase _database = TodoDatabase.instance;
  TaskList taskList = TaskList.empty();
  String? errorMessage;
  Function? lastCalledTaskSet;

  Future<void> setAllTasks () async {
    try{
      taskList = await _database.getAllTasks();
      log('All tasks set!');
    } catch (e) {
      errorMessage = 'Failed to load all tasks: $e';
      log(errorMessage!);
    } finally {
      lastCalledTaskSet = setAllTasks;
      notifyListeners();
    }
  }
  
  Future<void> setDoneTasks () async {
    try{
      taskList = await _database.getDoneTasks();
      log('Done tasks set!');
    } catch (e) {
      errorMessage = 'Faield to set done tasks: $e';
      log(errorMessage!);
    } finally {
      lastCalledTaskSet = setDoneTasks;
      notifyListeners();
    }
  }

  Future<void> addTask (Task task) async {
    try {
      int id = await _database.createTask(task);
      task.id = id;
      taskList.add(task);
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
        int index = taskList.tasks.indexWhere((element) => element.id == task.id);
        if (index != -1) {
          taskList.tasks[index] = task;
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
}