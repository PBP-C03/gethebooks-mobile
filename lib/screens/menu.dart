import 'package:flutter/material.dart';
import 'package:gethebooks/app/qna-forum/qnapage.dart';
import 'package:gethebooks/screens/profile.dart';
import 'package:gethebooks/screens/login.dart';
import 'package:gethebooks/screens/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gethebooks/app/cart-book/screens/cartbook.dart';
import 'package:gethebooks/models/book.dart';
import 'package:gethebooks/screens/list_book.dart';
import 'package:gethebooks/screens/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ShopItem {
  final String name;
  final IconData icon;

  ShopItem(this.name, this.icon);
}

class MyHomePage extends StatelessWidget {
  final String username;
  // const MyHomePage({Key? key}) : super(key: key);
  const MyHomePage({Key? key, required this.username}) : super(key: key);

  Future<List<Book>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse('https://gethebooks-c03-tk.pbp.cs.ui.ac.id/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Book> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Book.fromJson(d));
      }
    }
    return listProduct;
  }

    void _onItemTapped(int index, BuildContext context) {
      switch (index) {
        case 0:
          // Home is already the current page
          break;
        case 1:
          // Navigate to Katalog Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProductPage(username: username)),
          );
          break;
        case 2:
          // Navigate to QnA Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ForumPage()),
          );
          break;

        // Handle other cases for Chat and Profile
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(username: username)),
          );  
   // Function to handle logout
      }
    }

    
    
    // Card for each book in the horizontal list view
    Widget _buildBookCard(Book book) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        elevation: 5, // Shadow effect
        child: Container(
          width: 150, // Fixed width for symmetry
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  book.fields.image,
                  height: 100, // Fixed height for image
                  width: double.infinity, // Image width matches card
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.fields.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      book.fields.author,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'IDR ${book.fields.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Stok: ${book.fields.stocks}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    void _handleLogout() async {
      var response = await http.post(
        Uri.parse(
            'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/auth/logout/'), // Update with your logout URL
        headers: {"Content-Type": "application/json"},
      );

      // Check if logout is successful
      if (response.statusCode == 200) {
        // If logout is successful, navigate the user to the login page
        user = UserData(isLoggedIn: false, username: "guest");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        // If logout failed, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed. Please try again.')),
        );
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'GeTheBooks',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 0,
          onItemTapped: (index) => _onItemTapped(index, context),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.yellow[100],
            // Widget wrapper yang dapat discroll
            child: Padding(
              padding: const EdgeInsets.all(15.0), // Set padding dari halaman
              child: Column(
                // Widget untuk menampilkan children secara vertikal
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Selamat Datang,',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 15.0), // Berikan ruang di sebelah kiri
                        child: IconButton(
                          icon: const Icon(
                            Icons.shopping_cart,
                            size: 35,
                          ),
                          onPressed: () {
                            // Navigate to the cart page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          '${user.username}!',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: const EdgeInsets.all(
                        16.0), // Memberikan jarak antara container dan widget lainnya
                    width: MediaQuery.of(context).size.width -
                        32, // Mengambil lebar layar dan mengurangi margin
                    height: 200,
                    decoration: BoxDecoration(
                      color:
                          Colors.yellow, // Ganti dengan warna yang diinginkan
                      borderRadius: BorderRadius.circular(
                          30), // Memberikan sudut yang bulat
                      boxShadow: [
                        // Menambahkan shadow
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Warna shadow
                          spreadRadius:
                              0, // Menentukan seberapa jauh shadow menyebar dari setiap sisi box
                          blurRadius: 10, // Kekaburan shadow
                          offset: const Offset(0,
                              5), // Posisi shadow secara horizontal dan vertikal
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

                  // Horizontal ListView for books
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 220, // Adjust the height to fit the content
                      child: FutureBuilder<List<Book>>(
                        future: fetchProduct(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No products found'));
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final book = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: _buildBookCard(book),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        onPressed: _handleLogout,
                        child: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Logout button color
                          onPrimary: Colors.white, // Logout text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

// class ShopCard extends StatelessWidget {
//   final ShopItem item;

//   const ShopCard(this.item, {super.key}); // Constructor

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.indigo,
//       child: InkWell(
//         // Area responsive terhadap sentuhan
//         onTap: () {
//           // Memunculkan SnackBar ketika diklik
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(SnackBar(
//                 content: Text("Kamu telah menekan tombol ${item.name}!")));
//         },
//         child: Container(
//           // Container untuk menyimpan Icon dan Text
//           padding: const EdgeInsets.all(8),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   item.icon,
//                   color: Colors.white,
//                   size: 30.0,
//                 ),
//                 const Padding(padding: EdgeInsets.all(3)),
//                 Text(
//                   item.name,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }