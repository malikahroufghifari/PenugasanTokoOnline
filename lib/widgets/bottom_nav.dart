import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/models/user_login.dart';

const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

class BottomNav extends StatefulWidget {
  int activePage;
  BottomNav(this.activePage);
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  UserLogin userLogin = UserLogin();
  String? role;
  getDataLogin() async {
    var user = await userLogin!.getUserLogin();
    if (user!.status != false) {
      setState(() {
        role = user.role;
      });
    } else {
      Navigator.popAndPushNamed(context, '/login');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLogin();
  }

  void getLink(index) {
    if (role == "admin") {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dashboardAdmin');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/etalaseAdmin');
      }
    } else if (role == "user") {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dashboardUser');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/riwayatPesan');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return role == "admin"
        ? BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: backgroundSoft,
            currentIndex: widget.activePage,
            onTap: (index) => getLink(index),

            selectedItemColor: primary,
            unselectedItemColor: accent.withOpacity(0.55),

            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.storage_rounded),
                label: 'Etalase',
              ),
            ],
          )
        : role == "user"
        ? BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: backgroundSoft,
            currentIndex: widget.activePage,
            onTap: (index) => getLink(index),

            selectedItemColor: primary,
            unselectedItemColor: accent.withOpacity(0.55),

            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded),
                label: 'Riwayat Pesanan',
              ),
            ],
          )
        : Text("");
  }
}
