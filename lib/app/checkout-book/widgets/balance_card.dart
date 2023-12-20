// ignore_for_file: library_private_types_in_public_api, must_be_immutable, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BalanceData {
  final int balance;
  final int price;
  final int amount;

  BalanceData(this.balance, this.price, this.amount);
}

class BalanceCard extends StatefulWidget {
  late BalanceData data;
  final VoidCallback?  status;

  BalanceCard(this.data, {Key? key, this.status}) : super(key: key);

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final _formKey = GlobalKey<FormState>();
  String _alamat = "";
  String _layanan = "";

  Future<void> _pay(var request) async {
    var response;
     Map<String, String> requestBody = <String,String>{
     "alamat": _alamat,
    "layanan": _layanan,
    };
    try{
      response = await request.post("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkout/pay/", json.encode(requestBody));
    // ignore: empty_catches
    }catch(e){}
    widget.status!();
  }
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding here
      child: Container(
        alignment: AlignmentDirectional.bottomCenter,

        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 330,
                  child: Row(
                    children: [
                      const Text(
                        "Saldo",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.wallet,
                        size: 25,
                      ),
                      Text(
                        "  Rp${widget.data.balance},00",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    onPressed: (widget.data.amount != 0 && widget.data.balance >= widget.data.price)
                        ? () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text('Form Pembayaran'),
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    hintText: "Alamat Pengiriman",
                                                    labelText: "Alamat Pengiriman",
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                  ),
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      _alamat = value!;
                                                    });
                                                  },
                                                  validator: (String? value) {
                                                    if (value == null || value.isEmpty) {
                                                      return "Deskripsi tidak boleh kosong!";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    hintText: "Layanan Pengiriman",
                                                    labelText: "Layanan Pengiriman",
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                  ),
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      _layanan = value!;
                                                    });
                                                  },
                                                  validator: (String? value) {
                                                    if (value == null || value.isEmpty) {
                                                      return "Deskripsi tidak boleh kosong!";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            ElevatedButton(
                                              child: const Text('Kembali'),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                            ElevatedButton(
                                              child: const Text('Bayar'),
                                              onPressed: () {
                                                if (_formKey.currentState!.validate()) {
                                                  _pay(request);
                                                  Navigator.pop(context);
                                                }
                                              }
                                            ),  
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        : null,
                    child: const Text('Bayar Pesanan',
                        style: TextStyle(
                          color: Colors.black
                        ),),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
