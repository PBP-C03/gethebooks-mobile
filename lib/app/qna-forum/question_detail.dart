import 'package:flutter/material.dart';
import 'models/question.dart';

class QuestionDetailPage extends StatelessWidget {
  final Question question;

  const QuestionDetailPage({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Detail'),
      ),
      backgroundColor: Color(0xFFFAF2D3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Title', question.fields.title, Colors.blueAccent),
            _buildDetailItem('Content', question.fields.content.toString(), Colors.green),
            _buildDetailItem('User ID', question.fields.user.toString(), Colors.orange),
            _buildDetailItem('Book Name', question.fields.book.toString(), Colors.purple),
            _buildDetailItem('Created At', question.fields.createdAt.toString(), Colors.red),
            SizedBox(height: 20),
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
                child: Text(
                  'Add Comment',
                  style: TextStyle(fontSize: 18, color: Colors.black), // Mengatur warna teks
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: color),
        ),
        SizedBox(height: 16),
        Divider(
          color: Colors.grey,
          height: 1,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
