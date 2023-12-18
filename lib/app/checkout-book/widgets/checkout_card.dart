import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gethebooks/app/checkout-book/screens/checkout_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class OrderItem {
  final int pk;
  final int book;
  final String name;
  final String author;
  final String image;
  final int amount;
  final int price;

  OrderItem(this.pk, this.book,this.name, this.author, this.image, this.amount, this.price);
}

class OrderCard extends StatefulWidget {
  final OrderItem item;
  final VoidCallback? changed;
  
  const OrderCard(this.item, {Key? key, this.changed}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late int _currentAmount;

  @override
  void initState() {
    super.initState();
    _currentAmount = widget.item.amount;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return _currentAmount == 0
        ? const SizedBox.shrink() // If the amount is 0, return an empty widget
        : Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 0.5,
              color: Colors.yellow.shade200,
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          widget.item.image,
                          fit: BoxFit.scaleDown,
                          errorBuilder: (context, error, stackTrace) {
                                return const Text('Image failed to load');
                              },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _truncateString(widget.item.name, 30),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_2_rounded,
                                size: 15,
                                color: Colors.grey,
                              ),
                              Text(
                                "  ${_truncateString(widget.item.author, 25)}",
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              const Icon(
                                Icons.payments_rounded,
                                size: 15,
                                color: Colors.grey,
                              ),
                              Text(
                                "  Rp${widget.item.price},00",
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,),
                              ),

                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  _updateAmount(widget.item,1,request);

                                },
                              ),
                              Text(
                                "$_currentAmount",
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  _updateAmount(widget.item,-1,request);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> _updateAmount(OrderItem item,int delta, var request) async {
    var response;
    if (delta > 0){
          try{
      response = await request.post("http://127.0.0.1:8000/checkout/inc-book/${item.book}/",json.encode({}));
      // ignore: empty_catches
      }catch(e){}
    }else{
      try{
      response = await request.post("http://127.0.0.1:8000/checkout/dec-book/${item.book}/",json.encode({}));
      // ignore: empty_catches
      }catch(e){}
    }
    final newAmount = _currentAmount + delta;
    setState(() {
      _currentAmount = newAmount.clamp(0, 999);
      widget.changed!();
    });
  }
  String _truncateString(String inputString, int maxLength) {
  if (inputString.length <= maxLength) {
    return inputString;
  } else {
    return inputString.substring(0, maxLength) + '...';
  }
}
}
