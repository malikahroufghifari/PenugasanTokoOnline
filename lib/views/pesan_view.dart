import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/controllers/cartProvider.dart';
import 'package:penugasan_tokoonline/models/cart_model.dart';
import 'package:penugasan_tokoonline/services/DBHelper.dart';
import 'package:penugasan_tokoonline/services/product.dart';
import 'package:penugasan_tokoonline/widgets/bottom_nav.dart';
import 'package:badges/badges.dart' as badges;

const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

class PesanView extends StatefulWidget {
  const PesanView({super.key});

  @override
  State<PesanView> createState() => _PesanViewState();
}

class _PesanViewState extends State<PesanView> {
  var dBHelper = DBHelper();
  final cartProvider = CartProvider();
  List? barang;

  @override
  void initState() {
    super.initState();
    getBarang();
    updateCount();
  }

  getBarang() async {
    var result = await ProductService().getBarangUser();
    setState(() {
      barang = result.data;
    });
  }

  void updateCount() async {
    await cartProvider.getData();
    setState(() {
      // Re-trigger build untuk memperbarui badge jika diperlukan
    });
  }

  void saveData(int index) async {
    // 1. Ambil data barang dari list berdasarkan index
    final item = barang![index];

    // 2. Cek apakah barang sudah ada di keranjang (pakai ID)
    var detail = await dBHelper.getCartListDetail(item.id);
    int qty = 0;

    if (detail.isNotEmpty) {
      qty = detail[0].quantity ?? 0;
    }

    // 3. Masukkan ke database menggunakan parameter 'title' (BUKAN nama_barang)
    await dBHelper.insert(
      Cart(
        id: item.id,
        barang_id: item.id.toString(),
        title: item.title, // Menggunakan properti 'title' dari model Cart
        quantity: qty + 1,
        harga_beli: item.harga,
        posterpath: item.posterPath,
      ),
    );

    // 4. Update UI
    updateCount();
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item.title} ditambahkan ke keranjang"),
        backgroundColor: accent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSoft,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        title: const Text(
          'Showcase',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 12.0),
            child: badges.Badge(
              badgeStyle: const badges.BadgeStyle(badgeColor: soft),
              badgeContent: ListenableBuilder(
                listenable: cartProvider,
                builder: (context, child) {
                  return Text(
                    '${cartProvider.counter}',
                    style: const TextStyle(
                      color: primaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              child: IconButton(
                onPressed: () => Navigator.pushNamed(context, "/keranjang"),
                icon: const Icon(Icons.shopping_cart_outlined, size: 28),
              ),
            ),
          ),
        ],
      ),
      body: barang != null
          ? ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: barang!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: primaryDark.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          child: Image.network(
                            "${barang![index].posterPath}",
                            width: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 110,
                              color: soft.withOpacity(0.3),
                              child: const Icon(Icons.inventory_2, color: primary),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  barang![index].title ?? "-",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rp ${barang![index].harga ?? 0}",
                                  style: const TextStyle(
                                    color: accent,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  barang![index].deskripsi ?? "-",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () => saveData(index),
                                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                                    label: const Text("Beli"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator(color: primary)),
      bottomNavigationBar: BottomNav(1),
    );
  }
}