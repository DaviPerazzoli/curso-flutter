import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class TodoListState extends ChangeNotifier{
  final TodoDatabase _database = TodoDatabase.instance;
  TaskList taskList = TaskList([Task.create(title: 'nova task',description: 'descricao foda', dueDate: DateTime.now())]);
  String? errorMessage;

  Future setAllTasks () async {
    try{
      taskList = await _database.getAllTasks();
      log('All tasks set!');
    } catch (e) {
      errorMessage = 'Failed to load all tasks: $e';
      log(errorMessage!);
    } finally {
      notifyListeners();
    }
  }
  
  Future setDoneTasks () async {
    try{
      taskList = await _database.getDoneTasks();
      log('Done tasks set!');
    } catch (e) {
      errorMessage = 'Faield to set done tasks: $e';
      log(errorMessage!);
    } finally {
      notifyListeners();
    }
  }

  Future addTask (Task task) async {
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
    }
  }

  Future updateTask (Task task) async {
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
    }
  }

  Future deleteAllTasks() async {
    try {
      _database.clearTasks();
      log('All tasks deleted!');
    } catch (e) {
      errorMessage = 'Failed to delete all tasks: $e';
      log(errorMessage!);
    } finally {
      notifyListeners();
    }
  }
}