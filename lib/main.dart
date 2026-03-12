import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/views/dashboard_admin.dart';
import 'package:penugasan_tokoonline/views/dashboard_user.dart';
import 'package:penugasan_tokoonline/views/etalase_admin.dart';
import 'package:penugasan_tokoonline/views/login_view.dart';
import 'package:penugasan_tokoonline/views/register_user_view.dart';
import 'package:penugasan_tokoonline/views/riwayat_pesanan.dart';
import 'package:penugasan_tokoonline/views/splashscreen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/register': (context) => RegisterUserView(),
        '/login': (context) => LoginView(),
        '/dashboardAdmin': (context) => DashboardAdminView(),
        '/dashboardUser': (context) => DashboardUserView(),
        '/riwayatPesan': (context) => RiwayatPesananUser(),
        '/etalaseAdmin': (context) => EtalaseAdminView(),
      },
    ),
  );
}
