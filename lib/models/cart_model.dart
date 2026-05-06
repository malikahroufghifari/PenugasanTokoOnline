class Cart {
  int? id;
  String? barang_id;
  String? title;
  int? quantity;
  double? harga_beli;
  String? posterpath;
  

  Cart({
    required this.id,
    required this.barang_id,
    required this.title,
    required this.quantity,
    required this.harga_beli,
    required this.posterpath, 
  });

  factory Cart.fromMap(Map<String, dynamic> data) {
    return Cart(
      id: data['id'],
      barang_id: data['barang_id'],
      title: data['title'],
      quantity: data['quantity'],
      harga_beli: data['harga_beli'],
      posterpath: data['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barang_id': barang_id,
      'title': title,
      'quantity': quantity,
      'harga_beli': harga_beli,
      'image': posterpath,
    };
  }
}