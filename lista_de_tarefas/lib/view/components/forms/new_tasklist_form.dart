import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lista_de_tarefas/todo_list_view_model/todo_list_state.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_repository/todo_list_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTaskListForm extends StatefulWidget {
  const NewTaskListForm({super.key});

  @override
  State<NewTaskListForm> createState() => _NewTaskListFormState();
}

class _NewTaskListFormState extends State<NewTaskListForm> {
  Color pickerColor = Colors.white;
  Color selectedColor = Colors.white;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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

    ThemeData theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
                    width: 50,
                    height: 50,
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
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8)), 
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed:() async {
                if (_formKey.currentState!.validate()) {
                  await state.addTaskList(TaskList(
                      name: _nameController.text,
                      color: selectedColor,
                    ));
                  _resetForm();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(localization.taskListAdded, style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.green,
                    )
                  );
                }
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Icon(Icons.add_circle, size: 25, color: theme.colorScheme.onPrimary,),
                  Text(' ${localization.addTaskList}', style: const TextStyle(fontSize: 16),)
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