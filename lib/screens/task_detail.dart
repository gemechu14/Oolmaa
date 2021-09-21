import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/helper/database_helper.dart';
import 'package:wallet/helper/model/task.dart';

class TaskDetail extends StatefulWidget {
  TaskDetail(this.task, this.title);

  final String title;
  final Task task;

  @override
  State<StatefulWidget> createState() {
    return _TaskDetail(this.task, this.title);
  }
}

class _TaskDetail extends State<TaskDetail> {
  _TaskDetail(task, title);
  String title;
  String task;
  String selectedPriority;
  static var _priorities = [
    'Low',
    'Medium',
    'High',
  ];
  

  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var selectedDate;
  var selectedTime;

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    titleController.text = widget.task.title;
    descriptionController.text = widget.task.description;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.delete))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _save();
          });
        },
        isExtended: false,
        child: Icon(Icons.save),
        tooltip: 'Save',
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
          children: [
            //First element

            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextFormField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                style: textStyle,
                onChanged: (value) {
                  widget.task.title = titleController.text;
                },
                validator: (input) =>
                    input.trim().isEmpty ? "Please enter task" : null,
                decoration: InputDecoration(
                    hintText: "Title",
                    labelText: 'Title',
                    labelStyle: textStyle,
                    hintStyle: textStyle,
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            //  Second element
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                cursorHeight: 17,
                maxLength: 250,
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  widget.task.description = descriptionController.text;
                },
                decoration: InputDecoration(
                    hintStyle: textStyle,
                    hintText: "Write some description....",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            //Third Element

            Padding(
              padding: EdgeInsets.all(1),
              child: TextFormField(
                readOnly: true,
                controller: dateController,
                onTap: () async {
                  _setDateHandler(context);

                  print(selectedDate);
                },
                validator: (input) =>
                    input.trim().isEmpty ? "Please select Date" : null,
                style: TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                    labelText: 'Date',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: DropdownButtonFormField(
                isDense: true,
                icon: Icon(Icons.arrow_drop_down_circle),
                iconSize: 20.0,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  labelStyle: textStyle,
                  labelText: 'Priority',
                ),
                iconEnabledColor: Theme.of(context).primaryColor,
                style: textStyle,
                items: _priorities.map((String listOfItem) {
                  return DropdownMenuItem<String>(
                      value: listOfItem, child: Text(listOfItem));
                }).toList(),
                onChanged: (selectedPriority) {
                  setState(() {
                    widget.task.priority = selectedPriority;
                  });
                },
                value: selectedPriority,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _save() async {
    if (_formKey.currentState.validate()) {
      print(widget.task.priority);
      moveToLastScreen();
      widget.task.title = titleController.text;

      if (widget.task.id != null) {
        // Case 1: Update operation

        await databaseHelper.updateTask(widget.task);
      } else {
        // Case 2: Insert Operation

        await databaseHelper.insertTask(widget.task);
      }
    }
  }

  _setDateHandler(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );
    if (picked != null) {
      {
        selectedDate = picked;
        _showTime();
      }
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  Future<void> _showTime() async {
    final TimeOfDay result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        selectedTime = result.format(context).toString();
        dateController.text =
            DateFormat.yMMMd().format(selectedDate) + " " + selectedTime;

        widget.task.date = dateController.text;
      });
    }
  }
}
