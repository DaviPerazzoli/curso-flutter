import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditTaskListForm extends StatefulWidget {
  const EditTaskListForm({super.key, required TaskList taskList, this.onSubmit}): _taskList = taskList;

  final TaskList _taskList;

  final VoidCallback? onSubmit;

  @override
  State<EditTaskListForm> createState() => _EditTaskListFormState();
}

class _EditTaskListFormState extends State<EditTaskListForm> {
  late Color pickerColor;
  late Color selectedColor;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    pickerColor = widget._taskList.color;
    selectedColor = widget._taskList.color;
    _nameController.text = widget._taskList.name;
    super.initState();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    setState(() {
      selectedColor = Colors.white;
      pickerColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<TodoListState>();
    AppLocalizations localization = AppLocalizations.of(context)!;

    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //* Tasklist name field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: localization.name,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localization.pleaseEnterName;
                }
                return null;
              },
            ),
          ),

          //* Tasklist color field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('${localization.color}:'),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {_showColorPicker(context, localization);},
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: selectedColor,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    
                  ),
                )
              ],
            )
          ),

          //* Submit button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8))),
              onPressed:() async {
                if (_formKey.currentState!.validate()) {
                  await state.updateTaskList(TaskList.fromExistent(
                      widget._taskList.tasks,
                      name: _nameController.text,
                      color: selectedColor,
                      id: widget._taskList.id!
                    ));
                  _resetForm();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(localization.taskListUpdated, style: const TextStyle(color: Colors.white)),
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
                  const Icon(Icons.edit, size: 25),
                  Text(' ${localization.editTaskList}', style: const TextStyle(fontSize: 16),)
                ],
              )
            ),
          )

        ],
      )
    );
  }

  void _showColorPicker(BuildContext context, AppLocalizations localization) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(localization.pickAColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: onColorChanged),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedColor = pickerColor;
              });
              Navigator.of(context).pop();
            }, 
            child: Text(localization.ok)
          )
        ],
      ),
    );
  }

  void onColorChanged(Color color) {
    setState(() {
      pickerColor = color;
    });
  }
}