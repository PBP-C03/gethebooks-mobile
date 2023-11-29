import 'package:flutter/material.dart';
import 'package:gethebooks/screens/list_book.dart';


class ShopItem {
  final String name;
  final IconData icon;

  ShopItem(this.name, this.icon);
}


class MyHomePage extends StatelessWidget {
    // const MyHomePage({Key? key}) : super(key: key);
    MyHomePage({Key? key, required this.username}) : super(key: key);

    final String username;

    final List<ShopItem> items = [
        ShopItem("Lihat Produk", Icons.checklist),
        ShopItem("Tambah Produk", Icons.add_shopping_cart),
        ShopItem("Logout", Icons.logout),
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        
        appBar: AppBar(
          title: const Text(
            'GeTheBooks',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Mengatur tipe agar semua item tetap ditampilkan
          items: const <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Katalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],

          onTap: (index) {
          if (index == 1) { // Assuming "Eksplorasi" is the second item
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductPage()),
            );
          }
        },
          // Menambahkan callback untuk menangani onTap event jika diperlukan:
          // onTap: _onItemTapped,
        ),

        body: SingleChildScrollView(
          // Widget wrapper yang dapat discroll
          child: Padding(
            padding: const EdgeInsets.all(10.0), // Set padding dari halaman
            child: Column(
              // Widget untuk menampilkan children secara vertikal
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                  child: Text(
                    'Selamat Datang $username!', // Text yang menandakan toko
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(16.0), // Memberikan jarak antara container dan widget lainnya
                  width: MediaQuery.of(context).size.width - 32, // Mengambil lebar layar dan mengurangi margin
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.yellow[700], // Ganti dengan warna yang diinginkan
                    borderRadius: BorderRadius.circular(16), // Memberikan sudut yang bulat
                    boxShadow: [ // Menambahkan shadow
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Warna shadow
                        spreadRadius: 0, // Menentukan seberapa jauh shadow menyebar dari setiap sisi box
                        blurRadius: 10, // Kekaburan shadow
                        offset: const Offset(0, 5), // Posisi shadow secara horizontal dan vertikal
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      // Isi child dengan konten yang diinginkan, misalnya gambar dan teks
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by Title',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
          
              ],
            ),
          ),
        ),
      );
    }
}

class ShopCard extends StatelessWidget {
  final ShopItem item;

  const ShopCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.indigo,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}