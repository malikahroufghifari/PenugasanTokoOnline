import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/models/response_data_list.dart';
import 'package:penugasan_tokoonline/services/product.dart';

const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

class EtalaseAdminView extends StatefulWidget {
  const EtalaseAdminView({super.key});
  @override
  State<EtalaseAdminView> createState() => _EtalaseAdminViewState();
}

class _EtalaseAdminViewState extends State<EtalaseAdminView> {
  ProductService barang = ProductService();
  List? product;
  Future<void> getBarang() async {
    ResponseDataList getBarang = await barang.getBarang();
    setState(() {
      product = getBarang.data;
    });
  }

  @override
  void initState() {
    super.initState();
    getBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: const Text(
          "Etalase Produk",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      body: product != null
          ? ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: product!.length,
              itemBuilder: (context, index) {
                final item = product![index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        /// 🔹 IMAGE
                        SizedBox(
                          height: 160,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(item.posterPath ?? ""),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// 🔹 DATA PRODUK
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              /// TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title ?? "-",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      item.deskripsi ?? "-",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),

                              /// BUTTON EDIT
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  // TODO edit produk
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
