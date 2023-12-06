import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class OrderItem {
  final int pk;
  final String name;
  final String author;
  final String image;
  final int amount;
  final int price;
  

  OrderItem(this.pk,this.name, this.author,this.image,this.amount,this.price);
}


class OrderCard extends StatelessWidget {
  final OrderItem item;

  const OrderCard(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4, // Add elevation for a subtle shadow effect
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reduced the size of the image using the SizedBox widget
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.scaleDown, // Maintain aspect ratio and cover the entire box
                  ),
                ),
                const SizedBox(width: 8), // Added padding between elements
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    Text(
                      "Author: ${item.author}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "Harga: ${item.price}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                Column(
                 children: [
                  IconButton(icon: const Icon(Icons.add_circle_outline), 
                              onPressed: () {}),
                  Text(
                      "Jumlah: ${item.amount}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black54),
                    ),

                  IconButton(icon: const Icon(Icons.remove_circle_outline), 
                              onPressed: () {}),
                                        ], 
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
