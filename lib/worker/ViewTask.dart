import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_details.dart';

class ViewTaskPage extends StatefulWidget {
  const ViewTaskPage({Key? key}) : super(key: key);

  @override
  _ViewTaskPageState createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tasks found'));
          }

          final tasks = snapshot.data!.docs.map((doc) {
            return Task.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>);
          }).toList();

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              Task task = tasks[index];
              return ListTile(
                title: Text(task.name),
                subtitle: Text(task.address),
                tileColor: task.state == 'completed' ? Colors.green[100] : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsPage(task: task),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
