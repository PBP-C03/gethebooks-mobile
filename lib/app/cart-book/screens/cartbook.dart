import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gethebooks/app/cart-book/models/book_cart.dart';
import 'package:gethebooks/app/cart-book/models/cart.dart';
import 'package:gethebooks/models/book.dart';
import 'package:http/http.dart' as http;


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
    futureBookcarts = fetchBookcarts();
    futureBooks = fetchBooks().then((books) {
      allBooks = books; // Store all books for searching
      return books;
    });
    futureCart = fetchCart();
  }

  void searchBooks(String query) {
    if (query.isNotEmpty) {
      // Use the booksMap for easy lookup and filter where book title contains the query
      setState(() {
        futureBooks = Future.value(allBooks?.where((book) => book.fields.title.toLowerCase().contains(query.toLowerCase())).toList());
      });
    } else {
      // If query is empty, display all books
      setState(() {
        futureBooks = Future.value(allBooks);
      });
    }
  }

  Future<List<Book>> fetchBooks() async {
    const bookUrl = 'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/json/'; 
    final response = await http.get(Uri.parse(bookUrl));

    if (response.statusCode == 200) {
      return bookFromJson(response.body); // Use your model's fromJson factory method
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Bookcart>> fetchBookcarts() async {
    const bookcartUrl = 'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/bookcart-json/'; 
    final response = await http.get(Uri.parse(bookcartUrl));

    if (response.statusCode == 200) {
      return bookcartFromJson(response.body); 
    } else {
      throw Exception('Failed to load bookcarts');
    }
  }

  Future<Cart> fetchCart() async {
    const cartUrl = 'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/cart-json/'; 
    final response = await http.get(Uri.parse(cartUrl));

    if (response.statusCode == 200) {
      List<Cart> carts = cartFromJson(response.body); 
      return carts.isNotEmpty ? carts.first : throw Exception('No carts found');
    } else {
      throw Exception('Failed to load cart');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.yellow[700], 
      ),
      body: Container(
        color: Colors.yellow[100],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onSubmitted: (value) => searchBooks(value),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Bookcart>>(
                future: futureBookcarts,
                builder: (context, snapshotBookcarts) {
                  if (snapshotBookcarts.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshotBookcarts.hasError) {
                    return Center(child: Text('Error: ${snapshotBookcarts.error}'));
                  }
                  if (!snapshotBookcarts.hasData || snapshotBookcarts.data!.isEmpty) {
                    return const Center(child: Text('Your cart is empty'));
                  }

                  // Now let's fetch the books details using the IDs from the bookcarts
                  return FutureBuilder<List<Book>>(
                    future: futureBooks,
                    builder: (context, snapshotBooks) {
                      if (!snapshotBooks.hasData) return const CircularProgressIndicator();

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
                            color: Colors.grey[100], 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0), // Rounded corners for card
                            ),
                            elevation: 12.0, // Shadow effect
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(17),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12), // Rounded corners for image
                                        child: Image.network(
                                          book.fields.image,
                                          width: 130,
                                          height: 170,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(book.fields.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 10),
                                            Text(book.fields.author, style: const TextStyle(fontSize: 16)),
                                            const SizedBox(height: 10),
                                            Text('IDR ${book.fields.price}', style: TextStyle( color: Colors.blue[600], fontSize: 16, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 10),
                                            Text('Notes: ${bookcart.fields.notes}', style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold)),
                                            // Your notes widget goes here
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(icon: const Icon(Icons.add_circle_outline), 
                                            onPressed: () {}),
                                          Text('${bookcart.fields.amount}'),
                                          IconButton(icon: const Icon(Icons.remove_circle_outline), 
                                            onPressed: () {}),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: const ButtonStyle(
                                          backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                                        ),
                                        onPressed: () {
                                          // Add note logic
                                        },
                                        child: Text('Tambahkan Notes', style: TextStyle(color: Colors.white),)
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Remove item logic
                                        },
                                        child: Text('Remove'),
                                        style: ElevatedButton.styleFrom(primary: Colors.red),
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

            FutureBuilder<Cart>(
              future: futureCart,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Text('Failed to load cart total');
                }
                final cart = snapshot.data!;
                return Container(
                  color: Colors.yellow[200], // Adjust the color to match your theme
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Harga:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Rp ${cart.fields.totalHarga}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Implement checkout logic
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[600], // Adjust the color to match your theme
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 18,
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
