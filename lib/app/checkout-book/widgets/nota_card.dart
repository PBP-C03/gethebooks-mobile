import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class NotaItem {
  final int pk;
  final String date;
  final int total_amount;
  final int total_harga;
  final String alamat;
  final String layanan;

  NotaItem(this.pk, this.date,this.total_amount, this.total_harga, this.alamat, this.layanan);
}

class NotaCard extends StatefulWidget {
  final NotaItem item;
  final VoidCallback? changed;
  
  const NotaCard(this.item, {Key? key, this.changed}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<NotaCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4,
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.date,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Jumlah Buku: ${widget.item.total_amount}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          Text(
                            "Harga: Rp${widget.item.total_harga}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          Text(
                            "Alamat: ${widget.item.alamat}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          Text(
                            "Alamat: ${widget.item.layanan}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              _delete(widget.item,request);

                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> _delete(NotaItem item, var request) async {
    var response;
    try{
      response = await request.post("http://127.0.0.1:8000/checkout/del-nota/${item.pk}/",json.encode({}));
      // ignore: empty_catches
      }catch(e){}
    widget.changed?.call();
  }
  String _truncateString(String inputString, int maxLength) {
  if (inputString.length <= maxLength) {
    return inputString;
  } else {
    return inputString.substring(0, maxLength) + '...';
  }
}
}
