import 'package:flutter/material.dart';
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
  final cartProvider = CartProvider();

  void updateCount() async {
    await cartProvider.getData();
    if (mounted) {
      setState(() {
        cartProvider.counter = cartProvider.cart.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateCount();
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
          'Keranjang Belanja',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
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
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              position: badges.BadgePosition.topEnd(top: -2, end: 2),
              child: const Icon(Icons.shopping_cart, size: 28),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: ListenableBuilder(
        listenable: cartProvider,
        builder: (context, child) {
          if (cartProvider.cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart_outlined,
                      size: 80, color: soft.withOpacity(0.5)),
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
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
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
                        /// ✅ IMAGE FIX
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: item.posterpath != null && item.posterpath!.isNotEmpty
                              ? Image.network(
                                  item.posterpath!,
                                  height: 85,
                                  width: 85,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                          width: 85,
                                          height: 85,
                                          color: backgroundSoft),
                                )
                              : Container(
                                  width: 85,
                                  height: 85,
                                  color: backgroundSoft,
                                ),
                        ),

                        const SizedBox(width: 12),

                        /// INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// ✅ TITLE FIX
                              Text(
                                item.title ?? "Produk",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: primaryDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "ID: ${item.barang_id ?? "-"}",
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 12),
                              ),

                              const SizedBox(height: 10),

                              PlusMinusButtons(
                                addQuantity: () {
                                  cartProvider.addQuantity(item.id!);
                                },
                                deleteQuantity: () {
                                  cartProvider.deleteQuantity(item.id!);
                                },
                                text: item.quantity?.toString() ?? "0",
                              ),
                            ],
                          ),
                        ),

                        /// DELETE
                        IconButton(
                          onPressed: () {
                            dBHelper.deleteCartItem(item.id!);
                            cartProvider.removeItem(item.id!);
                            cartProvider.removeCounter();
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
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ListenableBuilder(
        listenable: cartProvider,
        builder: (context, child) {
          return cartProvider.cart.isEmpty
              ? const SizedBox.shrink()
              : FloatingActionButton.extended(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () async {
                    /// ✅ FIX TYPE INT
                    List dataList = cartProvider.cart.map((i) {
                      return {
                        "barang_id": int.parse(i.barang_id!),
                        "qty": i.quantity
                      };
                    }).toList();

                    var data = {"pesan": dataList};

                    var result = await Pesan().saveToDB(data);

                    if (result.status == true) {
                      AlertMessage()
                          .showAlert(context, "Transaksi Berhasil!", true);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/riwayatPesan',
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      AlertMessage()
                          .showAlert(context, "Gagal melakukan transaksi", false);
                    }
                  },
                  icon: const Icon(Icons.payments_outlined),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}