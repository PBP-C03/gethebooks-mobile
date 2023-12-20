// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gethebooks/app/cart-book/models/book_cart.dart';
import 'package:gethebooks/app/cart-book/models/cart.dart';
import 'package:gethebooks/app/checkout-book/screens/checkout_page.dart';
import 'package:gethebooks/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Bookcart>> futureBookcarts;
  late Future<List<Book>> futureBooks;
  late Future<Cart> futureCart;
  final TextEditingController searchController = TextEditingController();

  List<Book>? allBooks;
  List<Bookcart>? allBookCarts;

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks().then((books) {
      allBooks = books;
      return books;
    });
  }

  void searchBooks(String query) {
    if (query.isNotEmpty) {
      setState(() {
        futureBooks = Future.value(allBooks
            ?.where((book) =>
                book.fields.title.toLowerCase().contains(query.toLowerCase()))
            .toList());
      });
    } else {
      setState(() {
        futureBooks = Future.value(allBooks);
      });
    }
  }

  void showAddNoteDialog(int bookCartId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String note = "";
        return AlertDialog(
          title: const Text("Add Note"),
          content: TextField(
            onChanged: (value) {
              note = value;
            },
            decoration: const InputDecoration(hintText: "Write a note here"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                addNoteToCart(bookCartId, note);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> removeFromCart(int bookCartId) async {
    final request = context.read<CookieRequest>();
    await request.postJson(
      'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/cartbook/remove-from-cart-json/',
      jsonEncode({"id": bookCartId.toString()}),
    );
    setState(() {
      futureBookcarts = fetchBookcarts(request);
    });
  }

  Future<void> tambahAmount(int bookCartId) async {
    final request = context.read<CookieRequest>();
    await request.postJson(
      'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/cartbook/tambah-amount-json/',
      jsonEncode({"tambah": bookCartId.toString()}),
    );
    setState(() {
      futureBookcarts = fetchBookcarts(request);
    });
  }

  Future<void> kurangAmount(int bookCartId) async {
    final request = context.read<CookieRequest>();
    await request.postJson(
      'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/cartbook/kurang-amount-json/',
      jsonEncode({"kurang": bookCartId.toString()}),
    );
    setState(() {
      futureBookcarts = fetchBookcarts(request);
    });
  }

  Future<void> addNoteToCart(int bookCartId, String note) async {
    final request = context.read<CookieRequest>();
    await request.postJson(
      'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/cartbook/add-note-json/',
      jsonEncode({"noteid": bookCartId.toString(), "notes": note}),
    );
    setState(() {
      futureBookcarts = fetchBookcarts(request);
    });
  }


  Future<List<Book>> fetchBooks() async {
    const bookUrl = 'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/json/';
    final response = await http
        .get(Uri.parse(bookUrl), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return bookFromJson(response.body);
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Bookcart>> fetchBookcarts(request) async {
    final response = await request.get('https://gethebooks-c03-tk.pbp.cs.ui.ac.id/bookcart-json/');
    List<Bookcart> listBookCart = [];
    for (var d in response) {
      if (d != null) {
        listBookCart.add(Bookcart.fromJson(d));
      }
    }
    return listBookCart;
  }

  Future<Cart?> fetchCart(request) async {
    final response = await request.get('https://gethebooks-c03-tk.pbp.cs.ui.ac.id/cart-json/');
    Cart? keranjang;
    for (var d in response) {
      if (d != null) {
        keranjang = Cart.fromJson(d);
      }
    }
    return keranjang;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        color: Colors.yellow[100],
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) => searchBooks(value),
                decoration: InputDecoration(
                  labelText: 'Search by Title',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => searchBooks(searchController.text),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),

            Expanded(
              child: FutureBuilder<List<Bookcart>>(
                future: fetchBookcarts(request),
                builder: (context, snapshotBookcarts) {
                  if (snapshotBookcarts.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshotBookcarts.hasError) {
                    return Center(
                        child: Text('Error: ${snapshotBookcarts.error}'));
                  }

                  if (!snapshotBookcarts.hasData ||
                      snapshotBookcarts.data!.isEmpty) {
                    // Tampilan ketika keranjang kosong
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_shopping_cart,
                            size: 75.0,
                            color: Colors.grey,
                          ),
                          Text(
                            "Tidak Ada Pesanan dalam Keranjang",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return FutureBuilder<List<Book>>(
                    future: futureBooks,
                    builder: (context, snapshotBooks) {
                      if (!snapshotBooks.hasData) {
                        return const CircularProgressIndicator();
                      }

                      // Create a map of book IDs to Book objects for easy lookup
                      Map<int, Book> booksMap = {
                        for (var book in snapshotBooks.data!) book.pk: book,
                      };

                      return ListView.builder(
                        itemCount: snapshotBookcarts.data!.length,
                        itemBuilder: (context, index) {
                          final bookcart = snapshotBookcarts.data![index];
                          final book = booksMap[bookcart.fields.book];

                          if (book == null) {
                            return const Text('');
                          }
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25.0), // Rounded corners for card
                            ),
                            elevation: 12.0, // Shadow effect
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(17),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          book.fields.image,
                                          width: 130,
                                          height: 170,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.book,color:Colors.grey,size: 115,);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(book.fields.title,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 10),
                                            Text(book.fields.author,
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                            const SizedBox(height: 10),
                                            Text('IDR ${book.fields.price}',
                                                style: TextStyle(
                                                    color: Colors.blue[600],
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 10),
                                            Text(
                                                'Notes: ${bookcart.fields.notes}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            // Your notes widget goes here
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                              icon: const Icon(Icons.add_circle_outline),
                                              onPressed: () {
                                                tambahAmount(bookcart.pk);
                                              }),
                                          Text('${bookcart.fields.amount}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                                          IconButton(
                                              icon: const Icon(Icons.remove_circle_outline),
                                              onPressed: () {
                                                kurangAmount(bookcart.pk);
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Colors.blue),
                                          ),
                                          onPressed: () => showAddNoteDialog(bookcart.pk),

                                          child: const Text(
                                            'Tambahkan Notes',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      // Tombol 'Remove'
                                      ElevatedButton(
                                        onPressed: () async {
                                          await removeFromCart(bookcart.pk);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red
                                            ),
                                            
                                        child: const Text('Remove',
                                          style: TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            FutureBuilder<Cart?>(
              future: fetchCart(request),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Text('Failed to load cart total');
                }
                final cart = snapshot.data!;
                return Container(
                  color: Colors.yellow, // Adjust the color to match your theme
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Harga:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Rp ${cart.fields.totalHarga}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OrderPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: CartPage()));
}
