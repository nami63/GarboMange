/*import 'package:flutter/material.dart';
import 'package:login/admin/admin_login.dart';
import 'package:login/admin/adminworker.dart';
import 'package:login/admin/customer.dart';
import 'package:login/admin/profile.dart';

// ignore: camel_case_types
class addash extends StatefulWidget {
  const addash({super.key});

  @override
  State<addash> createState() => _AddashState();
}

class _AddashState extends State<addash> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const hop(),
    WorkerPage(),
    UserPage(),
    const ProfilePage(),
    const LogoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GarboManage"),
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
        toolbarHeight: 50,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Workers',
            icon: Icon(Icons.work),
          ),
          BottomNavigationBarItem(
            label: 'Customers',
            icon: Icon(Icons.group),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Logout',
            icon: Icon(Icons.logout),
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 107, 100, 237),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// Define the different pages
// ignore: camel_case_types
class hop extends StatelessWidget {
  const hop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Page'));
  }
}

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('All Customer Details'));
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdLog()),
          );
        },
        child: const Text('Logout'),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/admin/admin_login.dart';
import 'package:login/admin/adminworker.dart';
import 'package:login/admin/customer.dart';
import 'package:login/admin/profile.dart';

import 'addash.dart';

class _AddashState extends State<Addash> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    WorkerPage(),
    CustomerPage(),
    const ProfilePage(),
    const LogoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GarboManage"),
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
        toolbarHeight: 50,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 107, 100, 237),
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Workers',
            icon: Icon(Icons.work),
          ),
          BottomNavigationBarItem(
            label: 'Customers',
            icon: Icon(Icons.group),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Logout',
            icon: Icon(Icons.logout),
          ),
        ],
        selectedItemColor: const Color.fromARGB(255, 107, 100, 237),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// Define the different pages
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Page'));
  }
}

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('All Customer Details'));
  }
}

class WorkerPage extends StatelessWidget {
  WorkerPage({super.key});

  final CollectionReference workers =
      FirebaseFirestore.instance.collection('workers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddWorkerPage()),
              );
            },
            child: const Text('Add Worker'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: workers.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    var worker = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(worker['name']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          workers.doc(worker.id).delete();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddWorkerPage extends StatelessWidget {
  AddWorkerPage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final CollectionReference workers =
      FirebaseFirestore.instance.collection('workers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Worker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                workers.add({'name': name});
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdLog()),
          );
        },
        child: const Text('Logout'),
      ),
    );
  }
}
