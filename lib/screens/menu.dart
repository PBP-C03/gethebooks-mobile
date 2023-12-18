import 'package:flutter/material.dart';
import 'package:gethebooks/app/qna-forum/qnapage.dart';
import 'package:gethebooks/screens/profile.dart';
import 'package:gethebooks/authentication/login.dart';
import 'package:gethebooks/authentication/user.dart';
import 'package:gethebooks/widgets/book_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gethebooks/app/cart-book/screens/cartbook.dart';
import 'package:gethebooks/models/book.dart';
import 'package:gethebooks/screens/list_book.dart';
import 'package:gethebooks/widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ShopItem {
  final String name;
  final IconData icon;

  ShopItem(this.name, this.icon);
}

class MyHomePage extends StatelessWidget {
  final String username;
  final TextEditingController searchController = TextEditingController();

  // const MyHomePage({Key? key}) : super(key: key);
  MyHomePage({Key? key, required this.username}) : super(key: key);

  Future<List<Book>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/json/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Book> listProduct = [];
    for (var d in data) {
      if (d != null) {
        Book book = Book.fromJson(d);
        if (book.fields.title.toLowerCase().contains(searchController.text.toLowerCase())) {
          listProduct.add(book);
        }
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

  
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    void _handleLogout() async {
      var response = await http.post(
        Uri.parse(
            'http://127.0.0.1:8000/auth/logout/'), 
        headers: {"Content-Type": "application/json"},
      );

      // Check if logout is successful
      if (response.statusCode == 200) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                // Widget untuk menampilkan children secara vertikal
                children: <Widget>[
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selamat Datang,',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${user.username}!',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: IconButton(
                        icon: const Icon(
                            Icons.shopping_cart,
                            size: 35,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CartPage()),
                            );
                          },
                        ),
                      )
                    ],
                  ),

                  Container(
                    margin: const EdgeInsets.all(16.0), // Memberikan jarak antara container dan widget lainnya
                    width: MediaQuery.of(context).size.width - 32, // Mengambil lebar layar dan mengurangi margin
                    height: 250,
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

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: 
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by Title',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () {
                                    searchController.clear();
                                    (context as Element).markNeedsBuild();
                                  },
                                )
                              : const Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                        ),
                        onChanged: (value) {
                          (context as Element).markNeedsBuild();
                        },
                        style: TextStyle(color: Colors.black),
                      ),
                  ),

                  // Horizontal ListView for books
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SizedBox(
                      height: 300, // Adjust the height to fit the content
                      child: FutureBuilder<List<Book>>(
                        future: fetchProduct(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
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
                                padding: const EdgeInsets.only(right: 18.0),
                                child: BookCard(book: book),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 20.0),
                  //     child: ElevatedButton(
                  //       onPressed: _handleLogout,
                  //       child: Text('Logout'),
                  //       style: ElevatedButton.styleFrom(
                  //         primary: Colors.red, // Logout button color
                  //         onPrimary: Colors.white, // Logout text color
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  
                ],
              ),
            ),
          ),
      )
    );
  }
}
