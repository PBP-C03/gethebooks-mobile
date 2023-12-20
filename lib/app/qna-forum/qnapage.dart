import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gethebooks/app/qna-forum/addquestion.dart';
import 'package:gethebooks/app/qna-forum/question_detail.dart';
import 'package:gethebooks/authentication/user.dart';
import 'package:gethebooks/screens/list_book.dart';
import 'package:gethebooks/screens/menu.dart';
import 'package:gethebooks/screens/profile.dart';
import 'package:gethebooks/widgets/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'models/question.dart'; // Pastikan model telah diimport dengan benar
import 'package:gethebooks/models/book.dart';


class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late Future<List<Question>> futureQuestions;
  late Future<List<Book>> futureBooks; 


  @override
  void initState() {
    super.initState();
    futureQuestions = fetchQuestions();
    futureBooks = fetchBooks(); 
  }

  Future<List<Book>> fetchBooks() async {
    const url = 'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/json/'; 
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return bookFromJson(response.body); 
    } else {
      throw Exception('Gagal memuat buku');
    }
  }

  Future<void> deleteQuestion(int questionId) async {
    final request = context.read<CookieRequest>();
    var response = await request.postJson(
      'https://gethebooks-c03-tk.pbp.cs.ui.ac.id/qna/delete-question-json/', 
      jsonEncode({"id": questionId.toString()}),
    );

    if (response["result"] == "Success!") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil Menghapus Forum')),
      );
      setState(() {
        futureQuestions = fetchQuestions();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu Bukan Pembuat Forum')),
      );
    }
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
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: const Text('QnA Forum', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellow,
      ),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Set to 1 for Katalog
        onItemTapped: (index) => _onItemTapped(index, context),
      ),

      body: Column(
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
                        ).then((value) {
                          // Cek jika nilai yang dikembalikan adalah true
                          if (value == true) {
                            setState(() {
                              // Panggil fetchQuestions untuk memperbarui daftar pertanyaan
                              futureQuestions = fetchQuestions();
                            });
                          }
                        });
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
              child: FutureBuilder<List<Question>>(
                future: futureQuestions,
                builder: (context, snapshotQuestions) {
                  if (snapshotQuestions.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshotQuestions.hasError) {
                    return Center(child: Text('Error: ${snapshotQuestions.error}'));
                  } else if (!snapshotQuestions.hasData || snapshotQuestions.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada pertanyaan ditemukan'));
                  }

                  return FutureBuilder<List<Book>>(
                    future: futureBooks,
                    builder: (context, snapshotBooks) {
                      if (snapshotBooks.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshotBooks.hasError) {
                        return Center(child: Text('Error: ${snapshotBooks.error}'));
                      } else if (!snapshotBooks.hasData) {
                        return const Center(child: Text('No book data found'));
                      }

                      final books = snapshotBooks.data!;
                      return ListView.builder(
                        itemCount: snapshotQuestions.data!.length,
                        itemBuilder: (context, index) {
                          final question = snapshotQuestions.data![index];
                          final book = books.firstWhere(
                            (b) => b.pk == question.fields.book, // Replace with actual field names
                          );

                          return Card(
                            elevation: 8.0,
                            margin: const EdgeInsets.all(8.0),
                            color: const Color(
                                0xFFFFDC00), // Warna kotak list pertanyaan
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              leading: book.fields.image != null
                                  ? Image.network(book.fields.image, width: 50, height: 50)
                                  : const SizedBox(width: 50, height: 50),
                              title: Text(
                                question.fields.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              subtitle: Text(question.fields.content),
                              trailing: question.fields.user == question.fields.user // Asumsi 'user.id' adalah ID pengguna saat ini
                                  ? IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => deleteQuestion(question.pk),
                                    )
                                  : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuestionDetailPage(question: question),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
      )
      // body: FutureBuilder<List<Question>>(
      //   future: futureQuestions,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //       return const Center(child: Text('Tidak ada pertanyaan ditemukan'));
      //     }

      //     return Column(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.fromLTRB(
      //               16.0, 32.0, 16.0, 16.0), // Sesuaikan padding
      //           child: Column(
      //             children: [
      //               const Text(
      //                 'Have some question? Share with us!',
      //                 style: TextStyle(
      //                     fontSize: 20.0, fontWeight: FontWeight.bold),
      //               ),
      //               const SizedBox(
      //                   height: 16.0), // Spasi antara teks dan tombol
      //               ElevatedButton(
      //                 onPressed: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) => AddQuestionPage(),
      //                     ),
      //                   ).then((value) {
      //                     // Cek jika nilai yang dikembalikan adalah true
      //                     if (value == true) {
      //                       setState(() {
      //                         // Panggil fetchQuestions untuk memperbarui daftar pertanyaan
      //                         futureQuestions = fetchQuestions();
      //                       });
      //                     }
      //                   });
      //                 },
      //                 style: ElevatedButton.styleFrom(
      //                   primary: const Color(
      //                       0xFFFFDC00), // Warna tombol Add Question
      //                   padding:
      //                       const EdgeInsets.all(20.0), // Ubah padding tombol
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(12.0),
      //                     side: const BorderSide(
      //                         color: Colors.black), // Border hitam
      //                   ),
      //                 ),
      //                 child: const Text(
      //                   'Add Question',
      //                   style: TextStyle(
      //                       fontSize: 18.0,
      //                       color: Colors.black), // Warna teks hitam
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),

      //         Expanded(
      //           child: ListView.builder(
      //             itemCount: snapshot.data!.length,
      //             itemBuilder: (context, index) {
      //               final question = snapshot.data![index];

                    // return Card(
                    //   elevation: 0, // Hapus shadow dari Card
                    //   margin: const EdgeInsets.symmetric(vertical: 8.0),
                    //   color: const Color(
                    //       0xFFFFDC00), // Warna kotak list pertanyaan
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12.0),
                    //   ),
                    //   child: ListTile(
                    //     title: Text(
                    //       question.fields.title,
                    //       style: const TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16.0,
                    //       ),
                    //     ),
                    //     subtitle: Text(question.fields.content),
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) =>
                    //               QuestionDetailPage(question: question),
                    //         ),
                    //       );
                    //     },
                    //     // Tidak ada border pada ListTile
                    //   ),
                    // );
      //             },
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
