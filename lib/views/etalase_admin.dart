import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/widgets/bottom_nav.dart';

const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

class EtalaseAdminPage extends StatefulWidget {
  const EtalaseAdminPage({super.key});

  @override
  State<EtalaseAdminPage> createState() => _EtalaseAdminPageState();
}

class _EtalaseAdminPageState extends State<EtalaseAdminPage> {
  final List<Map<String, dynamic>> produk = [
    {
      "nama": "Wortel Segar",
      "harga": "5.000",
      "image": "carrot.png",
      "stok": 12,
    },
    {
      "nama": "Bawang Merah",
      "harga": "12.000",
      "image": "shallot.png",
      "stok": 8,
    },
    {
      "nama": "Susu Fresh Milk",
      "harga": "32.000",
      "image": "milk.png",
      "stok": 5,
    },
    {
      "nama": "Daging Sapi",
      "harga": "95.000",
      "image": "meat.png",
      "stok": 4,
    },
  ];

  void tambahStok(int index) {
    setState(() {
      produk[index]["stok"]++;
    });
  }

  void kurangStok(int index) {
    setState(() {
      if (produk[index]["stok"] > 0) {
        produk[index]["stok"]--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSoft,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: const Text(
          "Etalase Produk",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: search
            },
            icon: const Icon(Icons.search_rounded, color: Colors.white),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_rounded, color: Colors.white),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: produk.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.74,
        ),
        itemBuilder: (context, index) {
          final item = produk[index];
          return ProductCardAdmin(
            nama: item["nama"],
            harga: item["harga"],
            image: item["image"],
            stok: item["stok"],
            onPlus: () => tambahStok(index),
            onMinus: () => kurangStok(index),
          );
        },
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}

class ProductCardAdmin extends StatelessWidget {
  final String nama;
  final String harga;
  final String image;
  final int stok;

  final VoidCallback onPlus;
  final VoidCallback onMinus;

  const ProductCardAdmin({
    super.key,
    required this.nama,
    required this.harga,
    required this.image,
    required this.stok,
    required this.onPlus,
    required this.onMinus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO PRODUK
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
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
          ),

          // DETAIL PRODUK
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: primaryDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Rp $harga",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // LABEL STOK
                  Text(
                    "Stok: $stok",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primary.withOpacity(0.75),
                    ),
                  ),

                  const Spacer(),

                  // BUTTON CONTROL STOK
                  Row(
                    children: [
                      _stokButton(
                        icon: Icons.remove,
                        onTap: onMinus,
                        isDisabled: stok == 0,
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: soft, 
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: primary.withOpacity(0.12),
                            ),
                          ),
                          child: Text(
                            "$stok",
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),
                      _stokButton(icon: Icons.add, onTap: onPlus),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stokButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade200 : primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: isDisabled ? Colors.grey.shade500 : Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
