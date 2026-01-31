import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/widgets/bottom_nav.dart';

class PesanView extends StatefulWidget {
  const PesanView({super.key});
  @override
  State<PesanView> createState() => _PesanViewState();
}

class _PesanViewState extends State<PesanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Pesan"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Text("Pesan"),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
