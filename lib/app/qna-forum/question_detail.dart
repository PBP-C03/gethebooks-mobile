import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'models/question.dart';

class BookQuestionDetail {
  final int id;
  final String title;

  BookQuestionDetail({required this.id, required this.title});

  factory BookQuestionDetail.fromJson(Map<String, dynamic> json) {
    return BookQuestionDetail(
      id: json['pk'],
      title: json['fields']['title'],
    );
  }
}

class QuestionDetailPage extends StatefulWidget {
  final Question question;

  const QuestionDetailPage({Key? key, required this.question}) : super(key: key);

  @override
  _QuestionDetailPageState createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  late Future<List<BookQuestionDetail>> booksFuture;

  @override
  void initState() {
    super.initState();
    booksFuture = fetchBooks();
  }

  Future<List<BookQuestionDetail>> fetchBooks() async {
    const url = 'http://127.0.0.1:8000/json/'; 
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<dynamic> booksJson = jsonDecode(utf8.decode(response.bodyBytes));
      return booksJson.map((json) => BookQuestionDetail.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Detail'),
      ),
      backgroundColor: const Color(0xFFFAF2D3),
      body: FutureBuilder<List<BookQuestionDetail>>(
        future: booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No book data found'));
          }

          final books = snapshot.data!;
          final bookName = books.firstWhere(
            (book) => book.id == widget.question.fields.book, 
            orElse: () => BookQuestionDetail(id: -1, title: 'Unknown'),
          ).title;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem('Title', widget.question.fields.title, Colors.blueAccent),
                _buildDetailItem('Content', widget.question.fields.content.toString(), Colors.green),
                _buildDetailItem('User ID', widget.question.fields.user.toString(), Colors.orange),
                _buildDetailItem('Book Name', bookName, Colors.purple),
                _buildDetailItem('Created At', widget.question.fields.createdAt.toString(), Colors.red),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement action for the button (e.g., add comment)
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFDC00),
                    side: BorderSide(color: Colors.black),
                  ),
                  child: const Text(
                    'Add Comment',
                    style: TextStyle(fontSize: 18, color: Colors.black), // Mengatur warna teks
                  ),
                ),
              ),              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: color),
        ),
        const SizedBox(height: 16),
        const Divider(
          color: Colors.grey,
          height: 1,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
