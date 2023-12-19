import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gethebooks/app/cart-book/screens/cartbook.dart';
import 'package:gethebooks/app/review-book/screens/review_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gethebooks/models/book.dart';
import 'package:gethebooks/app/review-book/models/review.dart';
import '../widgets/review_card.dart';

class DetailBookPage extends StatefulWidget {
  final Book book;
  final int filter;
  final String username;

  const DetailBookPage({super.key, required this.book, required this.filter, required this.username});

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
    // var url = Uri.parse(
    //     'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/book/${book.pk}/get-reviews/'
    // );
    var url = Uri.parse(
      'http://127.0.0.1:8000/book/${book.pk}/get-reviews/'
    );
    var response = await http.get(url, headers: {"Content-Type": "application/json"},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
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
          }

          if (reviews.isEmpty) {
            average = 0;
          } else {
            average = totalRating / reviews.length.toDouble();
          }

          // ignore: unnecessary_null_comparison
          if (null == reviews) { // review section
            reviewWidget = const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              reviewWidget = const Column(
                children: [
                  Text(
                    "Tidak ada data review",
                    style:
                    TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              reviewWidget = ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (_, index) =>
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: reviews
                            .where((review) => review.fields.rating == filter || filter == 0)
                            .map((Review review) {
                          if (review.fields.username == username) {
                            hasReview = true;
                          }
                          totalRating += review.fields.rating;
                          return ReviewCard(review);
                        }).toList(),
                      ),
                    ),
              );
            }
          }

          ButtonStyle buttonStyle = ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(255, 220, 0, 1),
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
                onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewFormPage(book, username)));},
                child: Text('Add Review', style: textStyle)));
            bookUtilsWidgets.add(const SizedBox(width: 10, height: 50));
          }
          bookUtilsWidgets.add(ElevatedButton(
              style: buttonStyle,
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));},
              child: Text('Add To Cart', style: textStyle)));

          List<Widget> filterWidgets = [];
          filterWidgets.add(ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => DetailBookPage(book: book, filter: 0, username: username)));
                },
              child: Text(
                  'All',
                  style: textStyle
              )
          ));

          for (int i = 1; i <= 5; i++) {
            filterWidgets.add(const SizedBox(width: 10, height: 50));
            filterWidgets.add(ElevatedButton(
                style: buttonStyle,
                onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailBookPage(book: book, filter: i, username: username)));},
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
                  child: Text(
                      "Rp. ${book.fields.price}"
                  ),
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
                        '$average / 5.0 (${reviews.length})',
                      ),
                    ],
                  )
                ),
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

void main() {
  var json = {
    "model": "book.book",
    "pk": 25,
    "fields": {
      "isbn": "0439095026",
      "title": "Tell Me This Isn't Happening",
      "author": "Robynn Clairday",
      "year": 1999,
      "publisher": "Scholastic",
      "image": "http://images.amazon.com/images/P/0439095026.01.LZZZZZZZ.jpg",
      "price": 1003000,
      "stocks": 19
    }
  };
  runApp(MaterialApp(home: DetailBookPage(book: Book.fromJson(json), filter: 0, username: 'tes')));
}