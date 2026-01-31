import 'dart:async';
import 'package:flutter/material.dart';
import 'package:penugasan_tokoonline/models/user_login.dart';
import 'package:penugasan_tokoonline/widgets/bottom_nav.dart';

const Color primaryDark = Color(0xFF051F20);
const Color primary = Color(0xFF0B2B26);
const Color accent = Color(0xFF235347);
const Color soft = Color(0xFF8EB69B);
const Color backgroundSoft = Color(0xFFDAF1DE);

class DashboardUserView extends StatefulWidget {
  const DashboardUserView({super.key});

  @override
  State<DashboardUserView> createState() => _DashboardUserViewState();
}

class _DashboardUserViewState extends State<DashboardUserView> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? role;

  final PageController _promoController = PageController(
    viewportFraction: 0.88,
  );
  Timer? _promoTimer;
  int _promoIndex = 0;

  final List<Map<String, dynamic>> promoData = const [
    {
      "title": "Promo Sayur Segar",
      "desc": "Diskon 20% hari ini",
      "icon": Icons.local_offer_rounded,
    },
    {
      "title": "Gratis Ongkir",
      "desc": "Minimal belanja Rp50.000",
      "icon": Icons.local_shipping_rounded,
    },
    {
      "title": "Voucher Member",
      "desc": "Cashback sampai 10%",
      "icon": Icons.confirmation_number_rounded,
    },
  ];

  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        nama = user.nama_user;
        role = user.role;
      });
    }
  }

  void _startPromoAutoSlide() {
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_promoController.hasClients) return;

      _promoIndex++;
      if (_promoIndex >= promoData.length) _promoIndex = 0;

      _promoController.animateToPage(
        _promoIndex,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getUserLogin();
    _startPromoAutoSlide();
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSoft,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dashboard User",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nama == null
                              ? "Memuat data..."
                              : "Halo, $nama ($role)",
                          style: TextStyle(color: soft, fontSize: 14),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: arahkan ke halaman keranjang
                          },
                          icon: const Icon(
                            Icons.shopping_cart_rounded,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/login');
                          },
                          icon: const Icon(Icons.logout, color: Colors.white,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Expanded(
                      child: SummaryCard(
                        title: "Poin",
                        value: "120",
                        icon: Icons.stars_rounded,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: "Voucher",
                        value: "3",
                        icon: Icons.confirmation_number_rounded,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: "Stamp",
                        value: "5",
                        icon: Icons.local_activity_rounded,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 92,
                child: PageView.builder(
                  controller: _promoController,
                  itemCount: promoData.length,
                  itemBuilder: (context, index) {
                    final promo = promoData[index];
                    return PromoBar(
                      title: promo["title"],
                      desc: promo["desc"],
                      icon: promo["icon"],
                    );
                  },
                ),
              ),

              const SizedBox(height: 26),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Kategori",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: arahkan ke semua kategori
                      },
                      child: const Text(
                        "Lihat Semua",
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    menuItem("Sayur", "sayur.png", () {}),
                    menuItem("Buah", "fruits.png", () {}),
                    menuItem("Bumbu", "spices.png", () {}),
                    menuItem("Olahan Susu", "milk.png", () {}),
                    menuItem("Daging", "meat.png", () {}),
                    menuItem("Unggas", "chicken-breast.png", () {}),
                    menuItem("Seafood", "seafood.png", () {}),
                    menuItem("Frozen Food", "frozen-food.png", () {}),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              const ProductGridUser(
                data: [
                  {
                    "nama": "Wortel Segar",
                    "harga": "12.000",
                    "image": "carrot.png",
                  },
                  {
                    "nama": "Kentang 1Kg",
                    "harga": "18.000",
                    "image": "potato.png",
                  },
                  {
                    "nama": "Bawang Merah",
                    "harga": "22.000",
                    "image": "shallot.png",
                  },
                  {
                    "nama": "Cabai Merah",
                    "harga": "35.000",
                    "image": "pepper.png",
                  },
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(0),
    );
  }

  Widget menuItem(String title, String imagePath, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MenuIconCircle(imagePath: imagePath),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.12), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PromoBar extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;

  const PromoBar({
    super.key,
    required this.title,
    required this.desc,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.12), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Cek",
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuIconCircle extends StatelessWidget {
  final String imagePath;
  final double radius;
  final Color borderColor;
  final double borderWidth;
  final Color backgroundColor;
  final double padding;

  const MenuIconCircle({
    super.key,
    required this.imagePath,
    this.radius = 26,
    this.borderColor = primary,
    this.borderWidth = 1,
    this.backgroundColor = Colors.white,
    this.padding = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor.withOpacity(0.25),
          width: borderWidth,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: ClipOval(
          child: Image.asset(
            imagePath,
            width: radius * 1.6,
            height: radius * 1.6,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ProductGridUser extends StatelessWidget {
  final List<Map<String, String>> data;

  const ProductGridUser({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.74, // mirip shopee
        ),
        itemBuilder: (context, index) {
          final item = data[index];
          return ProductCardUser(
            nama: item["nama"] ?? "-",
            harga: item["harga"] ?? "0",
            image: item["image"] ?? "assets/images/default.png",
            onAdd: () {
              // TODO: add to cart
            },
          );
        },
      ),
    );
  }
}

class ProductCardUser extends StatelessWidget {
  final String nama;
  final String harga;
  final String image;
  final VoidCallback onAdd;

  const ProductCardUser({
    super.key,
    required this.nama,
    required this.harga,
    required this.image,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO PRODUK (dibuat lebih tinggi dan fleksibel)
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // DETAIL PRODUK
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Rp $harga",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: primary,
                    ),
                  ),
                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 18,
                      ),
                      label: const Text("+ Keranjang"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
