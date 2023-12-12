import 'package:flutter/material.dart';
import 'package:gethebooks/app/qna-forum/addquestion.dart';
import 'package:gethebooks/app/qna-forum/question_detail.dart';
import 'package:gethebooks/authentication/user.dart';
import 'package:gethebooks/screens/list_book.dart';
import 'package:gethebooks/screens/menu.dart';
import 'package:gethebooks/screens/profile.dart';
import 'package:gethebooks/widgets/navbar.dart';
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
    const url = 'http://127.0.0.1:8000/question-json/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return questionFromJson(response.body);
    } else {
      throw Exception('Gagal memuat pertanyaan');
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(username: user.username)),
        );
        break;
      case 1:
        // Navigate to Katalog Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProductPage(username: user.username)),
        );
        break;
      case 2:
        break;
      // Handle other cases for Chat and Profile
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(username: user.username)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QnA Forum'),
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Set to 1 for Katalog
        onItemTapped: (index) => _onItemTapped(index, context),
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
                padding: const EdgeInsets.fromLTRB(
                    16.0, 32.0, 16.0, 16.0), // Sesuaikan padding
                child: Column(
                  children: [
                    const Text(
                      'Have some question? Share with us!',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                        height: 16.0), // Spasi antara teks dan tombol
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
                        primary: const Color(
                            0xFFFFDC00), // Warna tombol Add Question
                        padding:
                            const EdgeInsets.all(20.0), // Ubah padding tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(
                              color: Colors.black), // Border hitam
                        ),
                      ),
                      child: const Text(
                        'Add Question',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black), // Warna teks hitam
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
                      color: const Color(
                          0xFFFFDC00), // Warna kotak list pertanyaan
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
