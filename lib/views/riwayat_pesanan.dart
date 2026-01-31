import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/widgets/bottom_nav.dart';

const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

class RiwayatPesananUser extends StatelessWidget {
  const RiwayatPesananUser({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orders = [
      {
        "alamat": "Jl. Danau Ranau Blok G2D...",
        "daftarProduk": "Wortel, Kubis, Kentang, Daun Bawang, Seledri ",
        "hargaProduk": 5000,
        "hargaAwal": null,
        "totalProduk": 5,
        "totalPembayaran": 8000,
        "image": "carrot.png",
      },
      {
        "alamat": "Jl. Danau Maninjau Selatan...",
        "daftarProduk": "Bawang Merah, Bawang Putih, Cabai Rawit, Ca... ",
        "hargaProduk": 12000,
        "hargaAwal": 14000,
        "totalProduk": 4,
        "totalPembayaran": 16000,
        "image": "shallot.png",
      },
      {
        "alamat": "Jl. Danau Ranau Blok G2D...",
        "daftarProduk": "Susu, Dada Ayam, Lada Putih, Rossemarry ",
        "hargaProduk": 32000,
        "hargaAwal": null,
        "totalProduk": 4,
        "totalPembayaran": 35000,
        "image": "milk.png",
      },
    ];

    return Scaffold(
      backgroundColor: backgroundSoft,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: primaryDark),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: fitur search
            },
            icon: const Icon(Icons.search_rounded, color: Colors.white),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = orders[index];
          return OrderHistoryCard(
            alamat: item["alamat"] ?? "-",
            daftarProduk: item["daftarProduk"] ?? "",
            hargaProduk: item["hargaProduk"] ?? 0,
            hargaAwal: item["hargaAwal"],
            totalProduk: item["totalProduk"] ?? 1,
            totalPembayaran: item["totalPembayaran"] ?? 0,
            imagePath: item["image"] ?? "assets/images/default.png",
            onBuyAgain: () {
              // TODO: beli lagi
            },
            onRating: () {
              // TODO: lihat penilaian
            },
          );
        },
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}

class OrderHistoryCard extends StatelessWidget {
  final String alamat;
  final String daftarProduk;

  final int hargaProduk;
  final int? hargaAwal;

  final int totalProduk;
  final int totalPembayaran;

  final String imagePath;

  final VoidCallback onBuyAgain;
  final VoidCallback onRating;

  const OrderHistoryCard({
    super.key,
    required this.alamat,
    required this.daftarProduk,
    required this.hargaProduk,
    required this.hargaAwal,
    required this.totalProduk,
    required this.totalPembayaran,
    required this.imagePath,
    required this.onBuyAgain,
    required this.onRating,
  });

  String rupiah(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final reverseIndex = s.length - i;
      buffer.write(s[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) buffer.write('.');
    }
    return "Rp${buffer.toString()}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primary.withOpacity(0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),

          // PRODUK
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 72,
                      height: 72,
                      color: backgroundSoft,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: primary.withOpacity(0.6),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alamat,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: primaryDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (daftarProduk.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        daftarProduk,
                        style: TextStyle(
                          fontSize: 12,
                          color: primary.withOpacity(0.65),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 12),

          // HARGA
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hargaAwal != null) ...[
                Text(
                  rupiah(hargaAwal!),
                  style: TextStyle(
                    color: primary.withOpacity(0.35),
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                rupiah(hargaProduk),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: primaryDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Total $totalProduk produk: ",
                style: TextStyle(
                  color: primary.withOpacity(0.7),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                rupiah(totalPembayaran),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: primaryDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: onRating,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryDark,
                  side: BorderSide(color: primary.withOpacity(0.25)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  "Lihat Penilaian",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onBuyAgain,
                style: OutlinedButton.styleFrom(
                  foregroundColor: accent,
                  side: const BorderSide(color: accent, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  "Beli Lagi",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
