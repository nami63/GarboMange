import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          // Filter out completed tasks
          var tasks = snapshot.data!.docs.where((task) {
            var data = task.data() as Map<String, dynamic>;
            return data.containsKey('completed') && data['completed'] != true;
          }).toList();

          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              return _buildTaskCard(context, task);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, DocumentSnapshot task) {
    var data = task.data() as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${data['address']}'),
            const SizedBox(height: 8),
            Text('Created At: ${_formatTimestamp(data['createdAt'])}'),
            const SizedBox(height: 16),
            _buildChecklist(task),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _markTaskComplete(context, task.id);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: const Text('Mark as Complete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklist(DocumentSnapshot task) {
    var data = task.data() as Map<String, dynamic>;
    List<dynamic> checklist = data['checklist'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: checklist.map((item) {
        return CheckboxListTile(
          title: Text(item['title']),
          value: item['checked'],
          onChanged: (value) {
            _updateChecklist(task.id, item['title'], value!);
          },
        );
      }).toList(),
    );
  }

  void _updateChecklist(String taskId, String title, bool checked) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference taskRef =
          FirebaseFirestore.instance.collection('tasks').doc(taskId);
      DocumentSnapshot snapshot = await transaction.get(taskRef);
      var data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> checklist = data['checklist'];
      int index = checklist.indexWhere((item) => item['title'] == title);
      checklist[index]['checked'] = checked;
      transaction.update(taskRef, {'checklist': checklist});
    });
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day} ${_getMonth(dateTime.month)} ${dateTime.year} at ${_formatTime(dateTime)}';
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  String _formatTime(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _markTaskComplete(BuildContext context, String taskId) {
    FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'completed': true,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task marked as complete')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark task as complete')),
      );
    });
  }
}
