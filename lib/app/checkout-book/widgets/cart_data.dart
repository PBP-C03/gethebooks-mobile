
import 'package:flutter/material.dart';

class CartData {
  final int pk;
  final int amount;
  final int price;

  CartData(this.pk, this.amount, this.price);

  int getAmount() {
    return amount;
  }
}

class CartCard extends StatefulWidget {
  final CartData cartData;

  CartCard(this.cartData, {Key? key}) : super(key: key);

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              const Text(
                'Daftar Pembelian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            // Display Product ID and Amount in a Row
            Row(
              children: [
                Text('Amount: ${widget.cartData.amount}'),
              ],
            ),
            // Display Price separately
            Text('Price: Rp${widget.cartData.price},00'),
            // Add other widgets here if needed
          ],
        ),
      ),
    );
  }
}
