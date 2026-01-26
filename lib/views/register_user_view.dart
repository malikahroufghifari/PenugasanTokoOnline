import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/services/user.dart';
import 'package:penugasan_tokoonline/widgets/alert.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  List roleChoice = ["admin", "user"];
  String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("Toko Online"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              elevation: 8,
              shadowColor: Colors.deepPurple.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Buat Akun",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      /// NAME
                      TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          labelText: "Name",
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// EMAIL
                      TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// ROLE
                      DropdownButtonFormField(
                        value: role,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: "Role",
                          prefixIcon: const Icon(Icons.admin_panel_settings),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: roleChoice.map((r) {
                          return DropdownMenuItem(
                            value: r,
                            child: Text(r),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            role = value.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Role harus dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// PASSWORD
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      /// BUTTON
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              var data = {
                                "name": name.text,
                                "email": email.text,
                                "role": role,
                                "password": password.text,
                              };

                              var result = await user.registerUser(data);

                              if (result.status == true) {
                                name.clear();
                                email.clear();
                                password.clear();
                                setState(() {
                                  role = null;
                                });

                                AlertMessage().showAlert(
                                  context,
                                  result.message,
                                  true,
                                );

                                Future.delayed(
                                  const Duration(seconds: 2),
                                  () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                                );
                              } else {
                                AlertMessage().showAlert(
                                  context,
                                  result.message,
                                  false,
                                );
                              }
                            }
                          },
                          child: const Text(
                            "DAFTAR",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
