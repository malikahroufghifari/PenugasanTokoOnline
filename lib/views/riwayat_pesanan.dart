import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/services/pesan.dart'; // Pastikan import service ini benar
import 'package:penugasan_tokoonline/widgets/bottom_nav.dart';

// Palette Warna Konsisten
const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

class RiwayatPesananUser extends StatefulWidget {
  const RiwayatPesananUser({super.key});

  @override
  State<RiwayatPesananUser> createState() => _RiwayatPesananUserState();
}

class _RiwayatPesananUserState extends State<RiwayatPesananUser> {
  List? historyData;
  bool isLoading = true;

  getHistory() async {
    setState(() => isLoading = true);
    try {
      var result = await Pesan().getHistory(); 
      setState(() {
        historyData = result.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error loading history: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSoft,
      appBar: AppBar(
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : historyData == null || historyData!.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(),
      bottomNavigationBar: BottomNav(2), // Index 2 biasanya untuk riwayat
    );
  }

  // Tampilan jika riwayat masih kosong
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_late_outlined,
              size: 100,
              color: soft.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              "Belum Ada Transaksi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Anda belum melakukan pembelian apapun.\nYuk, mulai belanja sekarang!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/pesan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.shopping_bag),
              label: const Text("Mulai Belanja"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: historyData!.length,
      itemBuilder: (context, index) {
        var item = historyData![index];
        

        double totalTransaksi = 0;
        if (item['detail'] != null) {
          for (var d in item['detail']) {
            totalTransaksi += (d['quantity'] * d['harga_beli']);
          }
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          child: ExpansionTile(
            shape: const Border(),
            leading: const CircleAvatar(
              backgroundColor: backgroundSoft,
              child: Icon(Icons.receipt_long, color: primary),
            ),
            title: Text(
              "Pesanan #${item['id_transaksi']}", // Sesuai Postman: id_transaksi
              style: const TextStyle(fontWeight: FontWeight.bold, color: primaryDark),
            ),
            subtitle: Text(
              "Tanggal: ${item['tgl_transaksi']}", // Sesuai Postman: tgl_transaksi
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.expand_more, color: accent),
            children: [
              const Divider(height: 1),
              // Detail barang
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: item['detail'].length, // Sesuai Postman: detail
                itemBuilder: (context, dIndex) {
                  var detail = item['detail'][dIndex];
                  return ListTile(
                    dense: true,
                    title: Text(
                      detail['nama_barang'] ?? "-", // Sesuai Postman: nama_barang
                      style: const TextStyle(fontWeight: FontWeight.w600)
                    ),
                    subtitle: Text("Jumlah: ${detail['quantity']}"), // Sesuai Postman: quantity
                    trailing: Text(
                      "Rp ${detail['harga_beli']}", // Sesuai Postman: harga_beli
                      style: const TextStyle(color: accent, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
              // Menampilkan Total jika ada item di dalam detail
              if (item['detail'].isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: backgroundSoft,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Pembayaran",
                        style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark),
                      ),
                      Text(
                        "Rp $totalTransaksi",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}