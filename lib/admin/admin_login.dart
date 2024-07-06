import 'package:flutter/material.dart';
import 'package:login/admin/admin_register.dart' as admin_register;
import 'package:login/auth/adminlogin.dart';

class AdLog extends StatefulWidget {
  const AdLog({super.key});

  @override
  State<AdLog> createState() => _AdLogState();
}

class _AdLogState extends State<AdLog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AdminAuth _adminAuth = AdminAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      width: 180,
                      height: 200,
                      top: 40,
                      left: 10,
                      child: Container(
                        width: 220,
                        height: 300,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/welcome.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text(
                            "Admin Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 227, 218, 234),
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: const Color.fromARGB(255, 107, 100, 237)
                            .withOpacity(0.7),
                      ),
                      style:
                          const TextStyle(color: Color.fromARGB(255, 25, 0, 0)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 222, 211, 228),
                        ),
                        filled: true,
                        border: InputBorder.none,
                        fillColor: const Color.fromARGB(255, 107, 100, 237)
                            .withOpacity(0.7),
                      ),
                      style:
                          const TextStyle(color: Color.fromARGB(255, 13, 0, 0)),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(255, 107, 100, 237),
                ),
                child: TextButton(
                  onPressed: () {
                    _adminAuth.signInAdmin(
                      context,
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const admin_register.adreg()),
                  );
                },
                child: const Center(
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'package:login/admin/admin_login.dart';
import 'package:login/admin/adminworker.dart';
import 'package:login/admin/customer.dart';
import 'package:login/admin/profile.dart';
import 'package:login/admin/addash.dart'; // Ensure this import

class AdminAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Addash()),
            );
          },
          child: const Text('Login as Admin'),
        ),
      ),
    );
  }
}*/
