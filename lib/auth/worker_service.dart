import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch tasks for the current worker
  Future<List<Map<String, dynamic>>> getTasksForWorker(String workerId) async {
    try {
      QuerySnapshot taskSnapshot = await _firestore
          .collection('tasks')
          .where('workerId', isEqualTo: workerId)
          .where('status', isEqualTo: 'pending')
          .get();

      return taskSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (error) {
      print('Error fetching tasks: $error');
      return [];
    }
  }

  // Delete task and update worker status
  Future<void> deleteTaskAndIncrementCompleted(
      String taskId, String workerId) async {
    if (taskId.isEmpty) {
      throw ArgumentError('Task ID cannot be empty');
    }
    if (workerId.isEmpty) {
      throw ArgumentError('Worker ID cannot be empty');
    }

    WriteBatch batch = _firestore.batch();

    try {
      // Delete the task
      DocumentReference taskRef = _firestore.collection('tasks').doc(taskId);
      batch.delete(taskRef);

      // Update the worker's document
      DocumentReference workerRef =
          _firestore.collection('workers').doc(workerId);
      batch.update(workerRef, {
        'tasksCompleted': FieldValue.increment(1),
        'lastTaskCompletedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      // Commit the batch
      await batch.commit();

      print('Task deleted and worker status updated successfully');
    } catch (error) {
      print('Error deleting task and updating worker status: $error');
      throw error;
    }
  }

  // Separate methods for individual operations (if needed)
  Future<void> deleteTask(String taskId) async {
    if (taskId.isEmpty) {
      throw ArgumentError('Task ID cannot be empty');
    }

    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      print('Task deleted successfully');
    } catch (error) {
      print('Error deleting task: $error');
      throw error;
    }
  }

  Future<void> incrementCompletedTasks(String workerId) async {
    if (workerId.isEmpty) {
      throw ArgumentError('Worker ID cannot be empty');
    }

    try {
      DocumentReference workerRef =
          _firestore.collection('workers').doc(workerId);
      await workerRef.update({
        'tasksCompleted': FieldValue.increment(1),
        'lastTaskCompletedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
      print('Worker status updated successfully');
    } catch (error) {
      print('Error updating worker status: $error');
      throw error;
    }
  }
}
