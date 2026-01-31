import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/services/user.dart';
import 'package:penugasan_tokoonline/widgets/alert.dart';

const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

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
  bool showPass = true;

  List roleChoice = ["admin", "user"];
  String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: soft,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("seller.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.all(20),
                child: Card(
                  elevation: 10,
                  shadowColor: primary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "SIGN UP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Ke pasar beli selada,",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: accent),
                          ),
                          Text(
                            "Yuk, masuk dulu ke akun anda!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: accent),
                          ),
                          const SizedBox(height: 32),

                          /// NAME
                          TextFormField(
                            controller: name,
                            decoration: InputDecoration(
                              labelText: "Name",
                              prefixIcon: const Icon(Icons.person_outline),
                              filled: true,
                              fillColor: backgroundSoft,
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
                              prefixIcon: const Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: backgroundSoft,
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
                              prefixIcon: const Icon(
                                Icons.admin_panel_settings_outlined,
                              ),
                              filled: true,
                              fillColor: backgroundSoft,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: roleChoice.map((r) {
                              return DropdownMenuItem(value: r, child: Text(r));
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
                            obscureText: showPass,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
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
                              filled: true,
                              fillColor: backgroundSoft,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
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
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
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
                                          context,
                                          '/login',
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
            ],
          ),
        ),
      ),
    );
  }
}
