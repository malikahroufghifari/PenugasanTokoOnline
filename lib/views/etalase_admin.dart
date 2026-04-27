import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/models/response_data_list.dart';
import 'package:penugasan_tokoonline/services/product.dart';
import 'package:penugasan_tokoonline/views/tambah_product_view.dart';

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
  List action = ["Update", "Hapus"];
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TambahProductView(title: "Tambah Barang", item: null),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
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
                                    /// NAMA
                                    Text(
                                      item.title ?? "-",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    /// DESKRIPSI
                                    Text(
                                      item.deskripsi ?? "-",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),

                                    const SizedBox(height: 6),

                                    /// STOK
                                    Text(
                                      "Stok: ${item.stok ?? 0}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    /// HARGA
                                    Text(
                                      "Rp ${item.harga ?? 0}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            primary, // pakai warna theme kamu
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// BUTTON EDIT
                              PopupMenuButton(
                                onSelected: (value) async {
                                  /// ================= UPDATE =================
                                  if (value == "Update") {
                                    var confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Update Produk"),
                                        content: Text(
                                          "Yakin ingin mengubah data produk ini?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text("Ya"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TambahProductView(
                                                title: "Update Produk",
                                                item: item,
                                              ),
                                        ),
                                      );

                                      getBarang(); // 🔥 refresh
                                    }
                                  }
                                  /// ================= HAPUS =================
                                  else if (value == "Hapus") {
                                    var confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Hapus Produk"),
                                        content: Text(
                                          "Yakin ingin menghapus produk ini?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text(
                                              "Hapus",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      var res = await barang.hapusBarang(
                                        context,
                                        item.id,
                                      );

                                      if (res.status == true) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(res.message)),
                                        );

                                        getBarang(); // 🔥 refresh list
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(res.message)),
                                        );
                                      }
                                    }
                                  }
                                },

                                itemBuilder: (context) {
                                  return action.map((r) {
                                    return PopupMenuItem(
                                      value: r,
                                      child: Text(r),
                                    );
                                  }).toList();
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
