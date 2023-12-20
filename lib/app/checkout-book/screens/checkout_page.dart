// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:gethebooks/app/checkout-book/widgets/cart_data.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:gethebooks/app/checkout-book/widgets/checkout_card.dart';
import 'package:gethebooks/app/checkout-book/widgets/balance_card.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<CartData> cartDataFuture;
  late Future<List<OrderItem>> orderItemFuture;
  late Future<BalanceData> balanceDataFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    cartDataFuture = fetchCart(request);
    orderItemFuture = fetchOrderItem(request);
    balanceDataFuture = fetchBalance(request);
  }

  Future<CartData> fetchCart(var request) async {
    var cartRaw = await request.get("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkout/get-cart/");
    var data = cartRaw[0];
    return CartData(data["pk"], data["fields"]["total_amount"], data["fields"]["total_harga"]);
  }

  Future<List<OrderItem>> fetchOrderItem(var request) async {
    List<OrderItem> orderData = [];
    var orderRaw = await request.get("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkout/get-order/");
    for (var data in orderRaw) {
      var fields = data["fields"];
      var bookRaw = await request.get("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkout/get-book/${fields["book"]}/");
      var bookFields = bookRaw[0]["fields"];
      orderData.add(
        OrderItem(
          data["pk"],
          fields["book"],
          bookFields["title"],
          bookFields["author"],
          bookFields["image"],
          fields["amount"],
          bookFields["price"],
        ),
      );
    }
    return orderData;
  }

  Future<BalanceData> fetchBalance(var request) async {
    var balanceRaw = await request.get("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/get_saldo/");
    var balance = balanceRaw[0]["fields"]["saldo"];
    var cartRaw = await request.get("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkout/get-cart/");
    var data = cartRaw[0];
    return BalanceData(balance,data["fields"]["total_harga"], data["fields"]["total_amount"]);
  }

  Future<void> refreshCartData() async {
    final request = context.read<CookieRequest>();
    final newCartData = await fetchCart(request);
    final newBalanceData = await fetchBalance(request);
    setState(() {
      balanceDataFuture = Future.value(newBalanceData);
      cartDataFuture = Future.value(newCartData);
      if (newCartData.amount == 0) {
        orderItemFuture = fetchOrderItem(request);
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellow[700],
      ),
      body: Container(
        color: Colors.yellow[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<CartData>(
              future: cartDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.amount == 0) {
                  return const Text("");
                } else {
                    CartData cartData = snapshot.data!;
                      return SizedBox(
                        height: 80,
                        child: CartCard(cartData),
                      );
                  }
              },
            ),
            Expanded(
              child: FutureBuilder<List<OrderItem>>(
                future: orderItemFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                              Icons.remove_shopping_cart_outlined,
                              color: Colors.grey,
                              size: 50,
                          ),
                        ),
                        Center(
                          child: Text(
                            "Tidak ada pemesanan dalam keranjang",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    List<OrderItem> orderData = snapshot.data!;
                    return ListView.builder(
                      itemCount: orderData.length,
                      itemBuilder: (context, index) {
                        return OrderCard(orderData[index], changed: refreshCartData);
                      },
                    );
                  }
                },
              ),
            ),
            FutureBuilder<BalanceData>(
              future: balanceDataFuture,
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data!.amount == 0) {
                return const SizedBox.shrink();
              } else {
                  BalanceData balanceData = snapshot.data!;
                    return BalanceCard(balanceData, status: refreshCartData,);
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}
