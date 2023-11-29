import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class OrderItem {
  final String name;
  final int amount;

  OrderItem(this.name, this.amount);
}

class OrderCard extends StatelessWidget {
  final OrderItem item;
  final int id;
  const OrderCard(this.item,this.id, {super.key}); 

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Material(
      color: Colors.grey[350],
      child: InkWell(
        onTap: () async{
        },
        
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}