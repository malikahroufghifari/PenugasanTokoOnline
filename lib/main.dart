import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/views/dashboard.dart';
import 'package:penugasan_tokoonline/views/login_view.dart';
import 'package:penugasan_tokoonline/views/register_user_view.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => RegisterUserView(),
        '/login': (context) => LoginView(),
        '/dashboard': (context) => DashboardView()
      },
    ),
  );
}
