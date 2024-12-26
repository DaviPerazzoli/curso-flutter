import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';

class NewTaskForm extends StatefulWidget {
  const NewTaskForm({super.key});

  @override
  State<NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _dueDate = null;
    });
    _formKey.currentState!.reset();
    _titleController.clear();
    _descriptionController.clear();
    _dueDateController.clear();
  }

  void _updateDueDateField(){
    _dueDateController.text = _dueDate != null? '${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}' : '';
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100),
      helpText: 'Select the due date',
      cancelText: 'Cancel',
      confirmText: 'ok'
    );
    
    if (pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }

    _updateDueDateField();
  }
  
  @override
  Widget build(BuildContext context) {
    var state = context.watch<TodoListState>();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          //* Task title field
          TextFormField(
            controller: _titleController,
            autofocus: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),

          //* Task description field
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),

          //* Task dueDate field
          TextFormField(
            controller: _dueDateController,
            onTap: () {
              _selectDueDate(context);
            }
            
          ),

          //* Submit button
          ElevatedButton(
            onPressed:() async {
              if (_formKey.currentState!.validate()) {
                await state.addTask(Task.create(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dueDate: _dueDate,
                  ));
                _resetForm();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task added!', style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.green,
                  )
                );

                

              }
            }, 
            child: const Icon(Icons.add_circle))

        ],
      )
    );
  }
}