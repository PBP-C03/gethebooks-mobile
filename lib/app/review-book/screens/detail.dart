// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:gethebooks/app/cart-book/screens/cartbook.dart';
import 'package:gethebooks/app/review-book/screens/review_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gethebooks/models/book.dart';
import 'package:gethebooks/app/review-book/models/review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/review_card.dart';

class DetailBookPage extends StatefulWidget {
  final Book book;
  final int filter;
  final String username;

  const DetailBookPage(
      {super.key,
      required this.book,
      required this.filter,
      required this.username});

  @override
  // ignore: library_private_types_in_public_api
  _DetailBookPageState createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  late Book book;
  late int filter;
  late String username;

  @override
  void initState() {
    super.initState();
    book = widget.book;
    filter = widget.filter;
    username = widget.username;
  }

  Future<List<Review>> fetchReview() async {
    var url = Uri.parse(
        'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/book/${book.pk}/get-reviews/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // ignore: non_constant_identifier_names
    List<Review> list_review = [];
    for (var d in data) {
      if (d != null) {
        list_review.add(Review.fromJson(d));
      }
    }
    return list_review;
  }

  Future<void> addToCart(int bookId) async {
    final request = context.read<CookieRequest>();
    await request.postJson(
      'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/cartbook/add-to-cart-json/',
      jsonEncode({"book_id": bookId}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: const Text(
          'Detail Buku',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: FutureBuilder(
        future: fetchReview(),
        builder: (context, AsyncSnapshot snapshot) {
          Widget imageWidget;
          imageWidget = Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(book.fields.image, fit: BoxFit.cover),
            ),
          );

          Widget reviewWidget;
          bool hasReview = false;
          double totalRating = 0;
          double average = 0;
          List<Review> reviews = snapshot.data!;

          for (Review review in reviews) {
            totalRating += review.fields.rating;
            if (review.fields.username == username) {
              hasReview = true;
            }
          }

          if (reviews.isEmpty) {
            average = 0;
          } else {
            average = totalRating / reviews.length.toDouble();
          }

          // ignore: unnecessary_null_comparison
          if (null == reviews) {
            // review section
            reviewWidget = const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              reviewWidget = const Column(
                children: [
                  Text(
                    "Tidak ada data review",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              List<Review> filteredReviews = filter != 0
                  ? reviews
                      .where((review) => review.fields.rating == filter)
                      .toList()
                  : reviews.toList();
              if (filteredReviews.isEmpty) {
                reviewWidget = const Column(
                  children: [
                    Text(
                      "Tidak ada data review",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                reviewWidget = ListView.builder(
                    itemCount: filteredReviews.length,
                    itemBuilder: (_, index) {
                      Review review = filteredReviews[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 5.0, right: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReviewCard(review),
                          ],
                        ),
                      );
                    });
              }
            }
          }

          ButtonStyle buttonStyle = ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(255, 220, 0, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadowColor: Colors.black,
          );

          TextStyle textStyle = const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          );

          List<Widget> bookUtilsWidgets = [];
          if (!hasReview) {
            bookUtilsWidgets.add(ElevatedButton(
                style: buttonStyle,
                // onPressed: () => showAddBookBottomSheet(context),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReviewFormPage(book, username)),
                  );
                },
                child: Text('Add Review', style: textStyle)));
          } else {
            bookUtilsWidgets.add(ElevatedButton(
                style: buttonStyle,
                onPressed: null,
                child: Text('Add Review', style: textStyle)));
          }
          bookUtilsWidgets.add(const SizedBox(width: 10, height: 50));
          if (book.fields.stocks != 0) {
            bookUtilsWidgets.add(ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  addToCart(book.pk);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartPage()));
                },
                child: Text('Add To Cart', style: textStyle)));
          } else {
            bookUtilsWidgets.add(ElevatedButton(
                style: buttonStyle,
                onPressed: null,
                child: Text('Add To Cart', style: textStyle)));
          }

          List<Widget> filterWidgets = [];
          filterWidgets.add(ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailBookPage(
                            book: book, filter: 0, username: username)));
              },
              child: Text('All', style: textStyle)));

          for (int i = 1; i <= 5; i++) {
            filterWidgets.add(const SizedBox(width: 10, height: 50));
            filterWidgets.add(ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailBookPage(
                              book: book, filter: i, username: username)));
                },
                child: Text(i.toString(), style: textStyle)));
          }

          return Center(
            child: Column(
              children: [
                Expanded(child: imageWidget),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    book.fields.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    book.fields.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text("Rp. ${book.fields.price}"),
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        Text(
                          '${average.toStringAsFixed(2)} / 5.0 (${reviews.length})',
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bookUtilsWidgets,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: filterWidgets,
                ),
                Expanded(child: reviewWidget),
              ],
            ),
          );
        },
      ),
    );
  }
}
