import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:penugasan_tokoonline/views/checkout_page.dart';
import 'package:penugasan_tokoonline/views/dashboard_admin.dart';
import 'package:penugasan_tokoonline/views/dashboard_user.dart';
import 'package:penugasan_tokoonline/views/etalase_admin.dart';
import 'package:penugasan_tokoonline/views/keranjang.dart';
import 'package:penugasan_tokoonline/views/login_view.dart';
import 'package:penugasan_tokoonline/views/pesan_view.dart';
import 'package:penugasan_tokoonline/views/register_user_view.dart';
import 'package:penugasan_tokoonline/views/riwayat_pesanan.dart';
import 'package:penugasan_tokoonline/views/splashscreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/register': (context) => RegisterUserView(),
        '/login': (context) => LoginView(),
        '/dashboardAdmin': (context) => DashboardAdminView(),
        '/etalaseAdmin': (context) => EtalaseAdminView(),
        '/dashboardUser': (context) => DashboardUserView(),
        '/pesanUser' : (context) => PesanView(),
        '/keranjang': (context)=> CartScreen(),
        '/checkout': (context)=> CheckoutPageView(),
        '/riwayatPesan': (context) => RiwayatPesananUser(),
        
      },
    ),
  );
}
