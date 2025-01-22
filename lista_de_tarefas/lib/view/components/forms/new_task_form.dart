import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTaskForm extends StatefulWidget {
  const NewTaskForm({super.key, this.onSubmit});

  final VoidCallback? onSubmit;

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

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TodoListState>();
    AppLocalizations localization = AppLocalizations.of(context)!;

    ThemeData theme = Theme.of(context);

    Future<void> selectDueDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context, 
        initialDate: DateTime.now(),
        firstDate: DateTime.now(), 
        lastDate: DateTime(2100),
        helpText: localization.selectDueDate,
        cancelText: localization.cancel,
        confirmText: localization.ok
      );

      TimeOfDay pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: const TimeOfDay(hour: 0, minute: 0),
        helpText: localization.selectDueTime,
        confirmText: localization.ok,
        cancelText: localization.cancel,
      ) ?? const TimeOfDay(hour: 0, minute: 0);

      // pickedTime ??= const TimeOfDay(hour: 0, minute: 0);

      if (pickedDate != null) {
        setState(() {
          _dueDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }

      _updateDueDateField();
    }

    if (state.selectedTaskList == null) {
      return Center(child: Text(localization.noTaskListSelected));
    }

    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          //* Task title field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: localization.title,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization.pleaseEnterTitle;
                }
                return null;
              },
            ),
          ),

          //* Task description field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: localization.description,
              ),
            ),
          ),

          //* Task dueDate field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _dueDateController,
              onTap: () {
                selectDueDate(context);
              },
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: localization.dueDate,
              ),
              
            ),
          ),

          //* Submit button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8)),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary
              ),
              onPressed:() async {
                if (_formKey.currentState!.validate()) {
                  await state.addTask(Task.create(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dueDate: _dueDate,
                      taskListId: state.selectedTaskList!.id!
                    ));
                  _resetForm();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(localization.taskAdded, style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.green,
                    )
                  );
                  widget.onSubmit?.call();
                }
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Icon(Icons.add_circle, size: 25, color: theme.colorScheme.onPrimary),
                  Text(' ${localization.addTask}', style: const TextStyle(fontSize: 16),)
                ],
              )
            ),
          )

        ],
      )
    );
  }
}