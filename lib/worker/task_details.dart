import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Task class representing a task document in Firestore
class Task {
  final String taskId;
  final String address;
  final Timestamp createdAt;
  final String email;
  final bool isWorker;
  final GeoPoint location;
  final String map;
  final String name;
  final String phoneNumber;
  final String pickupData;
  final String pinCode;
  final String role;
  final bool session;
  final String state;
  final List<dynamic> wasteTypes;
  final String workerId;

  Task({
    required this.taskId,
    required this.address,
    required this.createdAt,
    required this.email,
    required this.isWorker,
    required this.location,
    required this.map,
    required this.name,
    required this.phoneNumber,
    required this.pickupData,
    required this.pinCode,
    required this.role,
    required this.session,
    required this.state,
    required this.wasteTypes,
    required this.workerId,
  });

  // Factory method to create a Task object from a Firestore document snapshot
  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Task(
      taskId: doc.id,
      address: data['address'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      email: data['email'] ?? '',
      isWorker: data['isWorker'] ?? false,
      location: data['location'] ?? GeoPoint(0, 0),
      map: data['map'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      pickupData: data['pickupData'] ?? '',
      pinCode: data['pinCode'] ?? '',
      role: data['role'] ?? '',
      session: data['session'] ?? false,
      state: data['state'] ?? '',
      wasteTypes: data['wasteTypes'] ?? [],
      workerId: data['workerId'] ?? '',
    );
  }
}

// WorkerService class handling tasks related to workers
class WorkerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Example method to increment completed tasks for a worker
  Future<void> incrementCompletedTasks(String workerId) async {
    // Implement your logic here
    print('Incrementing completed tasks for worker $workerId');
  }

  // Method to delete a task from Firestore
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      print('Task deleted successfully');
    } catch (e) {
      print('Error deleting task: $e');
      // Handle error as needed
    }
  }
}

// ViewTaskPage displaying a list of tasks
class ViewTaskPage extends StatefulWidget {
  const ViewTaskPage({Key? key}) : super(key: key);

  @override
  _ViewTaskPageState createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final WorkerService _workerService = WorkerService();

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
                tileColor: task.state == 'completed' ? Colors.red[100] : null,
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

// TaskDetailsPage displaying details of a selected task
class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final WorkerService _workerService = WorkerService();

  Future<void> _completeTask() async {
    try {
      await _workerService.incrementCompletedTasks(widget.task.workerId);
      await _workerService.deleteTask(widget.task.taskId);
      Navigator.pop(context); // Navigate back after completing task
    } catch (e) {
      print('Error completing task: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.task.name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Address: ${widget.task.address}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${widget.task.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Phone Number: ${widget.task.phoneNumber}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Pickup Data: ${widget.task.pickupData}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Pin Code: ${widget.task.pinCode}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('State: ${widget.task.state}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Role: ${widget.task.role}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Session: ${widget.task.session}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              'Waste Types: ${widget.task.wasteTypes.map((type) => type['name']).join(', ')}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text('Created At: ${widget.task.createdAt.toDate()}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              'Location: ${widget.task.location.latitude}, ${widget.task.location.longitude}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Container(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.task.location.latitude,
                      widget.task.location.longitude),
                  zoom: 14.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.task.email),
                    position: LatLng(widget.task.location.latitude,
                        widget.task.location.longitude),
                  ),
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _completeTask,
                child: Text('Complete Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Task Management App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: ViewTaskPage(),
  ));
}
