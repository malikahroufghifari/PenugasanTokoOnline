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
    setState(() {
      cartProvider.counter = cartProvider.cart.length;
    });
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
          badges.Badge(
            badgeContent: ListenableBuilder(
              listenable: cartProvider,
              builder: (context, child) {
                if (cartProvider.cart.isEmpty) {
                  return Text(
                    '0',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return Text(
                    '${cartProvider.counter}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
            position: badges.BadgePosition.topEnd(top: 0, end: 2),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          SizedBox(width: 20.0),
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
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: cartProvider.cart.length,
              itemBuilder: (context, index) {
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
                        Image(
                          height: 85,
                          width: 85,
                          image: NetworkImage(
                            cartProvider.cart[index].posterpath!,
                          ),
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.0),
                              RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: "Produk: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: primaryDark,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${cartProvider.cart[index].title!}\n',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        PlusMinusButtons(
                          addQuantity: () {
                            cartProvider.addQuantity(
                              cartProvider.cart[index].id!,
                            );
                          },
                          deleteQuantity: () {
                            cartProvider.deleteQuantity(
                              cartProvider.cart[index].id!,
                            );
                          },
                          text: cartProvider.cart[index].quantity.toString(),
                        ),
                        IconButton(
                          onPressed: () {
                            dBHelper.deleteCartItem(
                              cartProvider.cart[index].id!,
                            );
                            cartProvider.removeItem(
                              cartProvider.cart[index].id!,
                            );
                            cartProvider.removeCounter();
                          },
                          icon: Icon(
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
      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Settings",
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onPressed: () async {
          List dataList = cartProvider.cart.map((i) {
            return {"barang_id": i.barang_id, "qty": i.quantity};
          }).toList();
          var data = {"pesan": dataList};
          var result = await Pesan().saveToDB(data);
          if (result.status == true) {
            AlertMessage().showAlert(context, "Anda berhasil beli", true);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/riwayatPesan',
              (Route<dynamic> route) => false,
            );
          } else {
            AlertMessage().showAlert(context, "Anda berhasil beli", true);
          }
        },
        icon: const Icon(
          Icons.shopping_cart_checkout_rounded,
          color: Colors.white,
        ),
        label: const Text("Checkout"),
      ),
    );
  }
}
