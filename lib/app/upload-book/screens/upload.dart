import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gethebooks/app/upload-book/models/uploadbook.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddBookBottomSheet extends StatelessWidget {
  final Function(Map<String, dynamic>) uploadBook;

  const AddBookBottomSheet({Key? key, required this.uploadBook}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String isbn = '';
    String title = '';
    String author = '';
    String year = '';
    String publisher = '';
    String image = '';
    String price = '';
    String stocks = '';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'ISBN'),
              onChanged: (value) => isbn = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISBN';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) => title = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISBN';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Author'),
              onChanged: (value) => author = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISBN';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Year'),
              onChanged: (value) => year = value,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISBN';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Publisher'),
              onChanged: (value) => publisher = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISBN';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Link Image'),
              onChanged: (value) => image = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISBN';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              onChanged: (value) => price = value,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISBN';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Stocks'),
              onChanged: (value) => stocks = value,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISBN';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Map<String, dynamic> bookData = {
                    "isbn": isbn,
                    "title": title,
                    "author": author,
                    "year": year,
                    "publisher": publisher,
                    "image": image,
                    "price": price,
                    "stocks": stocks,
                  };
                  uploadBook(bookData);
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
