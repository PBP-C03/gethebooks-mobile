import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:gethebooks/app/checkout-book/widgets/checkout_card.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // Future<Map<String, dynamic>> fetchData(String endpoint) async {
  //   try {
  //     var url = Uri.parse('http://localhost:8000/$endpoint');
  //     var response = await http.get(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //     );

  //     if (response.statusCode == 200) {
  //       return jsonDecode(utf8.decode(response.bodyBytes));
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     throw Exception('Error: $error');
  //   }
  // }

  Future<List<OrderItem>> fetchOrderItem(var request) async {

    List<OrderItem> orderData = [];
    var orderRaw = await request.get("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkout/get-order/");
    for (var data in orderRaw){
      var fields = data["fields"];
      var bookRaw = await request.get("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkout/get-book/${fields["book"]}/");
      var bookFields = bookRaw[0]["fields"];
      orderData.add(
        OrderItem(
          data["pk"],
          bookFields["title"],
          bookFields["author"],
          bookFields["image"],
          fields["amount"],
          bookFields["price"])
        );
    }
    return orderData;
  }
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow[700],
      ),
      body: Container(
        color: Colors.yellow[100],
        child: FutureBuilder<List<OrderItem>>(
          future: fetchOrderItem(request),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available.'));
            } else {
              // Data is available, create a ListView.builder
              List<OrderItem> orderData = snapshot.data!;
              return ListView.builder(
                itemCount: orderData.length,
                itemBuilder: (context, index) {
                  return OrderCard(orderData[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }

}
