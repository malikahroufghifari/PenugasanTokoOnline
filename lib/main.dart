import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                                    // tambah ini
import 'package:penugasan_tokoonline/controllers/cartProvider.dart';        // tambah ini
import 'package:penugasan_tokoonline/views/dashboard_admin.dart';
import 'package:penugasan_tokoonline/views/dashboard_user.dart';
import 'package:penugasan_tokoonline/views/etalase_admin.dart';
import 'package:penugasan_tokoonline/views/keranjang.dart';
import 'package:penugasan_tokoonline/views/login_view.dart';
import 'package:penugasan_tokoonline/views/pesan_view.dart';
import 'package:penugasan_tokoonline/views/register_user_view.dart';
import 'package:penugasan_tokoonline/views/riwayat_pesanan.dart';
import 'package:penugasan_tokoonline/views/splashscreen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(                     // bungkus MaterialApp dengan ini
      create: (_) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(),
          '/register': (context) => RegisterUserView(),
          '/login': (context) => LoginView(),
          '/dashboardAdmin': (context) => DashboardAdminView(),
          '/etalaseAdmin': (context) => EtalaseAdminView(),
          '/dashboardUser': (context) => DashboardUserView(),
          '/pesanUser': (context) => PesanView(),
          '/keranjang': (context) => CartScreen(),
          '/riwayatPesan': (context) => RiwayatPesananUser(),
        },
      ),
    ),
  );
}