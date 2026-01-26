import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/services/user.dart';
import 'package:penugasan_tokoonline/widgets/alert.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;
  bool showPass = true;

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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/register');
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
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
                        "Halo!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Silakan login untuk melanjutkan",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 24),

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

                      /// PASSWORD
                      TextFormField(
                        controller: password,
                        obscureText: showPass,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPass = !showPass;
                              });
                            },
                            icon: Icon(
                              showPass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
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
                              setState(() {
                                isLoading = true;
                              });

                              var data = {
                                "email": email.text,
                                "password": password.text,
                              };

                              var result = await user.loginUser(data);

                              setState(() {
                                isLoading = false;
                              });

                              if (result.status == true) {
                                AlertMessage().showAlert(
                                  context,
                                  result.message,
                                  true,
                                );
                                Future.delayed(
                                  const Duration(seconds: 2),
                                  () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/dashboard',
                                    );
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
                          child: isLoading == false
                              ? const Text(
                                  "MASUK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
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
