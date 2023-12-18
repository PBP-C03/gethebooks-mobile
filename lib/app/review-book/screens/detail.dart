import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gethebooks/models/book.dart';
import 'package:gethebooks/app/review-book/models/review.dart';
import '../widgets/review_card.dart';

class DetailBookPage extends StatefulWidget {
  final Book book;
  final String username;

  const DetailBookPage({super.key, required this.book, required this.username});

  @override
  // ignore: library_private_types_in_public_api
  _DetailBookPageState createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  late Book book;
  late String username;

  @override
  void initState() {
    super.initState();
    book = widget.book;
    username = widget.username;
  }
  
  Future<List<Review>> fetchReview() async {
    // var url = Uri.parse(
    //     'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/book/${book.pk}/get-reviews/'
    // );
    var url = Uri.parse(
      'http://127.0.0.1/book/${book.pk}/get-reviews/'
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
          int totalRating = 0;
          List<Review> reviews = snapshot.data!;
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
                        children: reviews.map((Review review) {
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

          List<Widget> bookUtilsWidgets = [];
          if (!hasReview) {
            bookUtilsWidgets.add(ElevatedButton(onPressed: () {}, child: const Text('Add Review')));
          }
          bookUtilsWidgets.add(ElevatedButton(onPressed: () {}, child: const Text('Add To Cart')));

          List<Widget> filterWidgets = [];
          filterWidgets.add(ElevatedButton(onPressed: () {}, child: const Text('All')));
          for (int i = 1; i <= 5; i++) {
            filterWidgets.add(ElevatedButton(onPressed: () {}, child: Text(i.toString())));
          }

          return Column(
            children: [
              Expanded(child: imageWidget),
              Text(
                book.fields.title
              ),
              Text(
                book.fields.author
              ),
              Text(
                book.fields.price.toString()
              ),
              Text(
                "${Icons.star} ${totalRating / reviews.length} / 5.0 (${reviews.length})"
              ),
              Row(
                children: bookUtilsWidgets,
              ),
              Row(
                children: filterWidgets,
              ),
              Expanded(child: reviewWidget),
            ],
          );
        },
      ),
    );
  }
}