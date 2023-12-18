
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
      color: Colors.yellow.shade200,
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
               Container(
                 alignment: Alignment.centerLeft,
                child: const Text(
                  'Daftar Pembelian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Display Product ID and Amount in a Row
            Row(
              children: [
                const Icon(
                  Icons.shopping_cart_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
                Text('  ${widget.cartData.amount}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  ),
                ),
                // Display Price separately
                Container(
                  width: 10,
                ),
                const Icon(
                  Icons.payments_rounded,
                  size: 20,
                  color: Colors.grey,
                ),
                Text('  Rp${widget.cartData.price},00',
                style: const TextStyle(

                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),),
              // Add other widgets here if needed
              ],
            ),
          ],
        ),
      ),
    );
  }
}
