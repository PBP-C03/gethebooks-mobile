// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gethebooks/app/review-book/screens/detail.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:gethebooks/models/book.dart';

class ReviewFormPage extends StatefulWidget {
  final Book book;
  const ReviewFormPage(this.book, {super.key});

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  late Book book;

  @override
  void initState() {
    super.initState();
    book = widget.book;
  }

  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  String _review = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Review Form',
          ),
        ),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Rating",
                    labelText: "Rating",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _rating = int.parse(value!);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Rating cannot be an empty field!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Rating should be number only!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Review",
                    labelText: "Review",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _review = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Review cannot be an empty field!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black87),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                            // "https://gethebooks-c03-tk.pbp.cs.ui.ac.id/book/${book.pk}/create-review-flutter/",
                            "http://127.0.0.1/book/${book.pk}/create-review-flutter/",
                            jsonEncode(<String, String>{
                              'rating': _rating.toString(),
                              'review': _review,
                            })
                        );
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Review baru berhasil disimpan!"),
                          ));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailBookPage(book: book)
                              ),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                            Text("Terdapat kesalahan, silahkan coba lagi."),
                          ));
                        }
                        _formKey.currentState!.reset();
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}