import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gethebooks/app/upload-book/models/uploadbook.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({Key? key}) : super(key: key);

  @override
  _MyBooksPageState createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  late Future<List<Uploadbook>> futureUploadbooks;

  @override
  void initState() {
    super.initState();
    futureUploadbooks = fetchUploadbooks();
  }

  Future<List<Uploadbook>> fetchUploadbooks() async {
    // Replace with your actual API endpoint
    const url = 'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/uploadbook-json/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return uploadbookFromJson(response.body);
    } else {
      throw Exception('Failed to load upload books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
        actions: <Widget>[
          // Top Up button
          TextButton(
            onPressed: () {
              // Implement Top Up functionality
            },
            child: const Text('Top Up', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: FutureBuilder<List<Uploadbook>>(
        future: futureUploadbooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books uploaded yet'));
          }

          return ListView(
            children: snapshot.data!.map((uploadbook) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(uploadbook.fields.image, width: 100),
                  title: Text(uploadbook.fields.title),
                  subtitle: Text('Author: ${uploadbook.fields.author}\nPrice: IDR ${uploadbook.fields.price}\nStocks: ${uploadbook.fields.stocks}'),
                  isThreeLine: true,
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Implement Delete functionality
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add book functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MyBooksPage()));
}
