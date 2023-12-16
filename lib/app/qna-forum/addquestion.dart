import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddQuestionPage extends StatefulWidget {
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> _submitQuestion(request) async {
    final request = context.read<CookieRequest>();
    await request.postJson(url, data)

    final url = Uri.parse('http://127.0.0.1:8000/qna/ask_question_json/');
    
    Map<String, dynamic> data = {
      'title': titleController.text,
      'book_name': bookNameController.text,
      'content': contentController.text,
    };

    final response = await http.post(
      url,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['result'] == 'Success!') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question Submitted')),
        );
        // Clear text fields after successful submission
        titleController.clear();
        bookNameController.clear();
        contentController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit question')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Container(
        color: Color(0xFFFAF2D3), // Background color form
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Question Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: bookNameController,
                decoration: InputDecoration(labelText: 'Book Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a book name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitQuestion();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFDC00),
                  onPrimary: Colors.black,
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
