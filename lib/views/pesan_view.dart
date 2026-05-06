import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  List? barang;

  Future<void> getBarang() async {
    var result = await ProductService().getBarangUser();
    setState(() {
      barang = result.data;
    });
  }

  Future<void> saveData(int index, CartProvider cartProvider) async {
    var detail = await dBHelper.getCartListDetail(barang![index].id);
    int qty = 0;
    if (detail != null && detail.isNotEmpty) {
      qty = detail[0].quantity ?? 0;
    }
    dBHelper
        .insert(
          Cart(
            id: barang![index].id,
            barang_id: barang![index].id.toString(),
            title: barang![index].title,
            quantity: qty + 1,
            harga_beli: double.parse(barang![index].harga.toString()),
            posterpath: barang![index].posterPath,
          ),
        )
        .then((_) {
          // refresh dari DB → otomatis notify semua listener termasuk badge
          cartProvider.getData();
          debugPrint('Product Added to Cart');
        })
        .onError((error, stackTrace) {
          debugPrint(error.toString());
        });
  }

  @override
  void initState() {
    super.initState();
    getBarang();
    // ambil data keranjang dari DB saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // watch → widget rebuild otomatis saat cart berubah
    final cartProvider = context.watch<CartProvider>();

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
              onPressed: () {
                Navigator.pushNamed(context, "/keranjang");
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: barang != null
          ? ListView.builder(
              padding: const EdgeInsets.all(12.0),
              shrinkWrap: true,
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
                                  child: const Icon(
                                    Icons.inventory_2,
                                    color: primary,
                                  ),
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
                                  barang![index].title.toString(),
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primary,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        // kirim cartProvider ke saveData
                                        onPressed: () => saveData(index, cartProvider),
                                        icon: const Icon(
                                          Icons.add_shopping_cart,
                                          size: 18,
                                        ),
                                        label: const Text("Add to Cart"),
                                      ),
                                      const SizedBox(width: 6),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: primary,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(context, "/keranjang");
                                        },
                                        label: const Text("Beli"),
                                      ),
                                    ],
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