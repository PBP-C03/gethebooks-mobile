import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gethebooks/app/cart-book/models/book_card.dart';
// import 'package:pbp_flutter/widget/left_drawer.dart';

class OrderPage extends StatefulWidget {
    const OrderPage({Key? key}) : super(key: key);

    @override
    _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    try {
      var url = Uri.parse('http://localhost:8000/$endpoint');
      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }

}
Future<List<Book_Cart>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    // final int cart_id = 
    var cart_data = await fetchData("get-cart/");
    var cart_id = cart_data[0]["pk"];
    var user = cart_data[0]["user"];
    var cart_amount = cart_data[0]["total_amount"];
    var cart_price = cart_data[0]["total_harga"];

    var order_data = await fetchData("get-order/");

    // melakukan konversi data json menjadi object Product
    List<Book_Cart> listOrder = [];
    for (var d in order_data[0]) {
        if (d != null && d['fields']['carts'] == cart_id) {
            listOrder.add(Book_Cart.fromJson(d));
        }
    }
    return listOrder;
}

@override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Game List'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        ),
        // drawer:  LeftDrawer(id : id),
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
                            "Tidak ada data produk.",
                            style:
                                TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        ],
                    );
                } else {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              content: IntrinsicWidth(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "${snapshot.data![index].fields.name}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text("Price : ${snapshot.data![index].fields.price}",textAlign: TextAlign.center),
                                    const SizedBox(height: 5),
                                    Text("Description : ${snapshot.data![index].fields.description}",textAlign: TextAlign.center),
                                    const SizedBox(height: 5),
                                    Text("Amount : ${snapshot.data![index].fields.amount}",textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the alert
                                  },
                                  child: Text("Close"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data![index].fields.name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );

                    }
                }
            }));
    }
}