import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:penugasan_tokoonline/controllers/cartProvider.dart';
import 'package:penugasan_tokoonline/services/DBHelper.dart';
import 'package:penugasan_tokoonline/services/pesan.dart';
import 'package:penugasan_tokoonline/widgets/alert.dart';
import 'package:penugasan_tokoonline/widgets/tombol_plus_minus.dart';

const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var dBHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    // refresh data keranjang dari DB saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().getData();
    });
  }

  Future<void> _checkout(CartProvider cartProvider) async {
    List dataList = cartProvider.cart.map((i) {
      return {"barang_id": i.barang_id, "qty": i.quantity};
    }).toList();

    var data = {"pesan": dataList};
    var result = await Pesan().saveToDB(data);

    if (!mounted) return;

    if (result.status == true) {
      // kosongkan keranjang setelah checkout berhasil
      await dBHelper.clearCart();
      cartProvider.getData();

      AlertMessage().showAlert(context, "Anda berhasil beli", true);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/riwayatPesan',
        (Route<dynamic> route) => false,
      );
    } else {
      // tampilkan pesan gagal yang benar
      AlertMessage().showAlert(
        context,
        result.message ?? "Checkout gagal, coba lagi",
        false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: backgroundSoft,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        actions: [
          badges.Badge(
            badgeContent: Text(
              '${cartProvider.cart.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            position: badges.BadgePosition.topEnd(top: 0, end: 2),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: cartProvider.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 80,
                    color: soft.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keranjang Anda Kosong',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: primaryDark,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              shrinkWrap: true,
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
                final item = cartProvider.cart[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: primaryDark.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        // gambar produk dengan fallback kalau gagal load
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.posterpath!,
                            height: 85,
                            width: 85,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 85,
                                  width: 85,
                                  color: soft.withOpacity(0.3),
                                  child: const Icon(
                                    Icons.inventory_2,
                                    color: primary,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title ?? "-",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rp ${item.harga_beli?.toStringAsFixed(0) ?? 0}",
                                style: const TextStyle(
                                  color: accent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PlusMinusButtons(
                          addQuantity: () {
                            cartProvider.addQuantity(item.id!);
                          },
                          deleteQuantity: () {
                            cartProvider.deleteQuantity(item.id!);
                          },
                          text: item.quantity.toString(),
                        ),
                        IconButton(
                          onPressed: () async {
                            await dBHelper.deleteCartItem(item.id!);
                            cartProvider.removeItem(item.id!);
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: cartProvider.cart.isEmpty
          ? null // sembunyikan tombol checkout kalau keranjang kosong
          : FloatingActionButton.extended(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              onPressed: () => _checkout(cartProvider),
              icon: const Icon(Icons.shopping_cart_checkout_rounded),
              label: const Text("Checkout"),
            ),
    );
  }
}