import 'package:flutter/material.dart';
import 'package:gethebooks/app/qna-forum/addquestion.dart';
import 'package:gethebooks/app/qna-forum/question_detail.dart';
import 'package:http/http.dart' as http;
import 'models/question.dart'; // Pastikan model telah diimport dengan benar

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
    // TODO: Ganti dengan endpoint API yang sesuai
    const url = 'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/question-json/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return questionFromJson(response.body);
    } else {
      throw Exception('Gagal memuat pertanyaan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QnA Forum'),
      ),
      backgroundColor: const Color(0xFFFAF2D3), // Warna latar belakang
      body: FutureBuilder<List<Question>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada pertanyaan ditemukan'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0), // Sesuaikan padding
                child: Column(
                  children: [
                    Text(
                      'Have some question? Share with us!',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0), // Spasi antara teks dan tombol
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddQuestionPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFFFDC00), // Warna tombol Add Question
                        padding: const EdgeInsets.all(20.0), // Ubah padding tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: Colors.black), // Border hitam
                        ),
                      ),
                      child: const Text(
                        'Add Question',
                        style: TextStyle(fontSize: 18.0, color: Colors.black), // Warna teks hitam
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final question = snapshot.data![index];

                    return Card(
                      elevation: 0, // Hapus shadow dari Card
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: const Color(0xFFFFDC00), // Warna kotak list pertanyaan
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(
                          question.fields.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        subtitle: Text(question.fields.content),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionDetailPage(question: question),
                            ),
                          );
                        },
                        // Tidak ada border pada ListTile
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
