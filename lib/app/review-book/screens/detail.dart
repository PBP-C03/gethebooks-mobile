import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gethebooks/models/book.dart';
import 'package:gethebooks/app/review-book/models/review.dart';
import '../widgets/review_card.dart';

class DetailBookPage extends StatefulWidget {
  final Book book;

  const DetailBookPage({super.key, required this.book});

  @override
  // ignore: library_private_types_in_public_api
  _DetailBookPageState createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  late Book book;

  @override
  void initState() {
    super.initState();
    book = widget.book;
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
                          return ReviewCard(review);
                        }).toList(),
                      ),
                    ),
              );
            }
          }
          Widget filterWidget;
          filterWidget = const Text(
              "filter widget card"
          );
          return Column(
            children: [
              Expanded(child: imageWidget),
              const Text(
                "Book Title"
              ),
              const Text(
                "Book Author"
              ),
              const Text(
                "Book Price"
              ),
              const Text(
                "Star, 4.5 / 5.0 (289)"
              ),
              const Row(
                children: [
                  Text(
                    "Add review Button"
                  ),
                  Text(
                    "Add to Cart Button"
                  ),
                ],
              ),
              const Row(
                children: [
                  Text(
                    "filter review by rating card"
                  )
                ],
              ),
              Expanded(child: filterWidget),
              Expanded(child: reviewWidget),
            ],
          );
        },
      ),
    );
  }
}