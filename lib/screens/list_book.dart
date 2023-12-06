import 'package:flutter/material.dart';
import 'package:gethebooks/screens/menu.dart';
import 'package:gethebooks/screens/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gethebooks/models/book.dart';
import 'package:gethebooks/app/review-book/screens/detail.dart';

class ProductPage extends StatefulWidget {
  final String username;

  const ProductPage({Key? key, required this.username}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<List<Book>> fetchProduct() async {
      // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
      var url = Uri.parse(
          'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/json/');
      var response = await http.get(
          url,
          headers: {"Content-Type": "application/json"},
      );

      // melakukan decode response menjadi bentuk json
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      // melakukan konversi data json menjadi object Product
      List<Book> list_product = [];
      for (var d in data) {
          if (d != null) {
              list_product.add(Book.fromJson(d));
          }
      }
      return list_product;
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
          title: const Text('Katalog Buku'),
          ),

        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1, // Set to 1 for Katalog
          onItemTapped: (index) {
            if (index == 0) {
              // If we're tapping the 'Katalog' button, navigate to the catalog page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(username: widget.username)),
              );
            }
          },
        ),
          
          body: FutureBuilder(
              future: fetchProduct(),
              builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                  } else {
                      if (!snapshot.hasData) {
                      return const Column(
                          children: [
                          Text(
                              "Tidak ada Katalog Buku.",
                              style:
                                  TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          ],
                      );
                  } else {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) {
                          final book = snapshot.data![index];
                          
                          Widget imageWidget;
                          if (book.fields.image.isNotEmpty) {
                            imageWidget = Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15), // More rounded image
                                child: Image.network(book.fields.image, fit: BoxFit.cover),
                              ),
                            );
                          } else {
                            imageWidget = const SizedBox(height: 0);
                          }

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailBookPage(
                                    book: book,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Rounded corners for the card
                            ),
                            margin: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),

                                  Expanded(child: imageWidget), // Display book image with padding

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          book.fields.title,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Author: ${book.fields.author}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Rp ${book.fields.price}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Stok: ${book.fields.stocks}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          );
                        },
                      );
                    }
                  }
              }
            )
          );
      }
}
