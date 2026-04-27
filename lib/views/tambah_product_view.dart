import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penugasan_tokoonline/services/product.dart';
import 'package:penugasan_tokoonline/models/product_model.dart';
import 'package:penugasan_tokoonline/views/etalase_admin.dart';
import 'package:penugasan_tokoonline/widgets/alert.dart';


const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

class TambahProductView extends StatefulWidget {
  String title;
  ProductModel? item;
  TambahProductView({super.key, required this.title, required this.item});

  @override
  State<TambahProductView> createState() => _TambahProductViewState();
}

class _TambahProductViewState extends State<TambahProductView> {
  ProductService product = ProductService();
  final formkey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController stok = TextEditingController();
  TextEditingController harga = TextEditingController();
  File? selectedImage;
  bool? isLoading = false;

  Future getImage() async {
    setState(() {
      isLoading = true;
    });
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(img!.path);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      nama.text = widget.item!.title!;
      deskripsi.text = widget.item!.deskripsi!;
      stok.text = widget.item!.stok.toString();
      harga.text = widget.item!.harga.toString();
      selectedImage = null;
    } else {
      nama.clear();
      deskripsi.clear();
      stok.clear();
      harga.clear();
      selectedImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSoft,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      /// NAMA BARANG
                      TextFormField(
                        controller: nama,
                        decoration: InputDecoration(
                          labelText: "Nama Barang",
                          labelStyle: TextStyle(color: accent),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'harus diisi' : null,
                      ),

                      const SizedBox(height: 12),

                      /// DESKRIPSI
                      TextFormField(
                        controller: deskripsi,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Deskripsi",
                          labelStyle: TextStyle(color: accent),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'harus diisi' : null,
                      ),

                      const SizedBox(height: 12),

                      /// STOK
                      TextFormField(
                        controller: stok,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Stok",
                          labelStyle: TextStyle(color: accent),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'harus diisi' : null,
                      ),

                      const SizedBox(height: 12),

                      /// HARGA
                      TextFormField(
                        controller: harga,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Harga",
                          labelStyle: TextStyle(color: accent),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'harus diisi' : null,
                      ),

                      const SizedBox(height: 16),

                      /// BUTTON GAMBAR
                      TextButton(
                        onPressed: () {
                          getImage();
                        },
                        child: Text(
                          "Pilih Gambar",
                          style: TextStyle(color: primary),
                        ),
                      ),

                      const SizedBox(height: 10),

                      selectedImage != null
                          ? Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : isLoading == true
                          ? CircularProgressIndicator(color: primary)
                          : Center(
                              child: Text(
                                "Belum ada gambar",
                                style: TextStyle(color: soft),
                              ),
                            ),

                      const SizedBox(height: 20),

                      /// BUTTON SIMPAN
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              var data = {
                                "nama_barang": nama.text,
                                "deskripsi": deskripsi.text,
                                "stok": stok.text,
                                "harga": harga.text,
                              };

                              var result;

                              if (widget.item != null) {
                                result = await product.insertBarang(
                                  data,
                                  selectedImage,
                                  widget.item!.id!,
                                );
                              } else {
                                result = await product.insertBarang(
                                  data,
                                  selectedImage,
                                  null,
                                );
                              }

                              if (result.status == true) {
                                AlertMessage().showAlert(context, result.message, true);
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(context, '/etalaseAdmin');
                              }else{
                                AlertMessage().showAlert(context, result.message, false);
                              }
                            }
                          },
                          child: Text("Simpan"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
