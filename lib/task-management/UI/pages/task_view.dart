import 'package:flutter/material.dart';
import 'package:mind_track_flutter_app/shared/services/treatment_service.dart';

class TasksPage extends StatefulWidget {
  final int patientId;
  final String token;

  TasksPage({required this.patientId, required this.token});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late Future<List<String>> _tasksFuture;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchTasks();
    print("ending service");
  }

  Future<List<String>> _fetchTasks() async {
    final treatmentService = TreatmentService();
    return await treatmentService.getTasksByPatientId(widget.patientId, widget.token);
  }

  Future<void> _addTask() async {
    final treatmentService = TreatmentService();
    final data = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };
    final treatmentPlanId = await treatmentService.getTreatmentPlanIdByPatientId(widget.patientId, widget.token);

    await treatmentService.addTasks(treatmentPlanId, data, widget.token);
    setState(() {
      _tasksFuture = _fetchTasks();
    });
    Navigator.of(context).pop();
  }

  void _showAddTaskForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _addTask,
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: FutureBuilder<List<String>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks found'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final title = task.split(' - ')[0].split(': ')[1];
                final description = task.split(' - ')[1].split(': ')[1];
                return ListTile(
                  title: Text(title),
                  subtitle: Text(description),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskForm,
        child: Icon(Icons.add),
      ),
    );
  }
}