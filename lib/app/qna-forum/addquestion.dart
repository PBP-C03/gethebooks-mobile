import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookQuestion {
  final int id;
  final String title;

  BookQuestion({required this.id, required this.title});
}

class AddQuestionPage extends StatefulWidget {
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  int? selectedBookId;
  List<BookQuestion> books = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final url = Uri.parse('http://127.0.0.1:8000/json/');
    final response = await http.get(url);

    List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      books = data.map((item) => BookQuestion(id: item['pk'], title: item['fields']['title'])).toList();
    });

  }

  Future<void> _submitQuestion() async {
    final request = context.read<CookieRequest>();
    
    Map<String, dynamic> data = {
      'title': titleController.text,
      'book': selectedBookId.toString(),
      'content': contentController.text,
    };

    try {
      final response = await request.postJson('http://127.0.0.1:8000/qna/add-question-json/', jsonEncode(data));

      if (response['result'] == 'Success!') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question Submitted')),
        );

        // Clear text fields after successful submission
        titleController.clear();
        contentController.clear();

        // Kembali ke halaman sebelumnya
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit question: ${response['errors']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting question')),
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
              Container(
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<int>(
                    value: selectedBookId,
                    isExpanded: true, // Ensure the dropdown fits within the available space
                    hint: const Text('Select Your Book'),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedBookId = newValue!;
                      });
                    },
                    items: books.map<DropdownMenuItem<int>>((BookQuestion book) {
                      return DropdownMenuItem<int>(
                        value: book.id,
                        child: Text(book.title, overflow: TextOverflow.ellipsis), // Prevent overflow with ellipsis
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a book';
                      }
                      return null;
                    },
                  ),
                ),
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
