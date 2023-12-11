import 'package:flutter/material.dart';

class AddQuestionPage extends StatefulWidget {
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final _formKey = GlobalKey<FormState>();

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFDC00), // Warna tombol Submit
                  onPrimary: Colors.black, // Warna teks
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black), // Border hitam
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
