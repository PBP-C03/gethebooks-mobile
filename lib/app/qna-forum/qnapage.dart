import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/question.dart'; // Make sure to import your model correctly

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late Future<List<Question>> futureQuestions;

  @override
  void initState() {
    super.initState();
    futureQuestions = fetchQuestions();
  }

  Future<List<Question>> fetchQuestions() async {
    // TODO: Replace with your actual API endpoint
    const url = 'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/qna/forum/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return questionFromJson(response.body);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QnA Forum'),
      ),
      body: FutureBuilder<List<Question>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final question = snapshot.data![index];

              return Card(
                child: ListTile(
                  title: Text(question.fields.title),
                  subtitle: Text(question.fields.content),
                  // Add trailing buttons for Add Comment/Delete
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Implement Add Comment functionality
                        },
                        child: const Text('Add Comment'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          // Implement Delete functionality
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

