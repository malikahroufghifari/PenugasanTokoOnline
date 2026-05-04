import 'package:penugasan_tokoonline/services/url.dart' as url;

class ProductModel {
  int? id;
  String? title;
  String? deskripsi;
  int? stok;
  int? harga;
  String? posterPath;
  ProductModel({
    required this.id,
    required this.title,
    required this.deskripsi,
    required this.stok,
    required this.harga,
    required this.posterPath,
  });
  ProductModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    title = parsedJson["nama_barang"];
    deskripsi = parsedJson["deskripsi"];
    stok = parsedJson["stok"];
    harga = parsedJson["harga"];
    posterPath = "${url.BaseUrlTanpaAPi}/${parsedJson["image"]}";
  }
}