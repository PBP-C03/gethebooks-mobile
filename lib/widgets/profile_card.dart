import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfileData {
  final String name;
  final int balance;

  ProfileData(this.name, this.balance);
}

class ProfileCard extends StatefulWidget {
  final String name;
  final int initialBalance; // Store the initial balance

  const ProfileCard(this.name, this.initialBalance);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final _formKey = GlobalKey<FormState>();
  late int _saldo;
  late int _currentBalance; // Store the current balance in the state

  @override
  void initState() {
    super.initState();
    _currentBalance = widget.initialBalance; // Initialize current balance
  }

  Future<void> _topup(var request) async {
    var response;
    Map<String, String> requestBody = <String, String>{
      "data": "$_saldo",
    };
    try {
      response = await request.post("https://gethebooks-c03-tk.pbp.cs.ui.ac.id/topup/", json.encode(requestBody));
    } catch (e) {
    }
    setState(() {
        _currentBalance += _saldo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi! ${widget.name}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Saldo: $_currentBalance', // Display the current balance
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Top Up Saldo'),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: "Nominal",
                                          labelText: "Nominal",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _saldo = int.parse(value!);
                                          });
                                        },
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return "Nominal tidak boleh kosong!";
                                          }
                                          if (int.tryParse(value) == null) {
                                            return "Nominal harus berupa angka!";
                                          }
                                          if (int.tryParse(value)! <= 0) {
                                            return "Nominal tidak valid!";
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
                                    child: const Text('Topup'),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _topup(request);
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text('Top Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
