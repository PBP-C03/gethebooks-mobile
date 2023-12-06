import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gethebooks/models/book.dart';
import 'package:gethebooks/app/review-book/models/review.dart';

class DetailBookPage extends StatefulWidget {
  final Book book;

  const DetailBookPage({super.key, required this.book});

  @override
  _DetailBookPageState createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  Future<List<Review>> fetchReview() async {
    var url = Uri.parse(
        'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/book/${book.fields.id}/get-reviews/'
    );
    var response = await http.get(url, headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));
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
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${snapshot.data![index].fields.username}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.rating}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.date_added}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.review}"),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}