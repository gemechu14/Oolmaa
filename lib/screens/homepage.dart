import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet/helper/database_helper.dart';
import 'package:wallet/helper/model/task.dart';
import 'package:wallet/screens/drawerWidget.dart';
import 'package:wallet/screens/task_detail.dart';

class HomePage extends StatefulWidget {
  HomePage(this.title);

  final String title;
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList;
  int count = 0;
  int x = 0;
  bool check;

  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle = Theme.of(context).textTheme.headline6;

    if (taskList == null) {
      taskList = <Task>[];
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      drawer: DrawerWidget(),
      body: getTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToTaskDetail(Task('', '', ''), "Add Task");
        },
        child: Icon(Icons.add),
        tooltip: "Add tasks",
      ),
    );
  }

  getTaskList() async {
  
     updateListView();

    if (this.count == 0) {
      return ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int position) {
            return Center(
                child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              navigateToTaskDetail(
                                  Task('', '', ''), "Add Task");
                            },
                          ),
                        ),
                        Text(
                          'Hit the add button to add your task',
                          textScaleFactor: 1.3,
                        ),
                      ],
                    )));
          });
    } else
      return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  navigateToTaskDetail(this.taskList[position], 'Edit Task');
                },
                leading: CircleAvatar(
                    backgroundColor:
                        getPriorityColor(this.taskList[position].priority),
                    child: Icon(
                      Icons.timeline,
                    )),
                title: Text(
                  this.taskList[position].title,
                ),
                subtitle: Text(this.taskList[position].date),
                trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey),
                  onTap: () {
                    _deleteTask(context, taskList[position]);
                  },
                ),
              ),
            ),
          );
        },
      );
  }

  // Returns the priority color
  Color getPriorityColor(String priority) {
    if (priority == 'High') {
      return Colors.red;
    } else if (priority == 'Medium') {
      return Colors.yellow;
    } else
      return Colors.grey;
  }

  void _deleteTask(BuildContext context, Task task) async {
    int result = await databaseHelper.deleteTask(task.id);
    if (result != 0) {
      _showSnackBar(context, 'Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
        content: Row(
      children: [
        Text(message),
      ],
    ));
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((listOfTasks) {
        setState(() {
          this.taskList = listOfTasks;

          this.count = listOfTasks.length;
          if (this.count > 0) {
            this.check = true;
            print(check);
          }
        });
      });
    });
  }

  void navigateToTaskDetail(Task task, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TaskDetail(task, title);
    }));
    if (result == true) {
      updateListView();
      //flutter stack
      //awesome flutter snippet
      // brackets list view separated

    }
  }
}


