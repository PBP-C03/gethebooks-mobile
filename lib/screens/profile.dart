import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gethebooks/app/checkout-book/widgets/nota_card.dart';
import 'package:gethebooks/app/upload-book/models/uploadbook.dart';
import 'package:gethebooks/app/upload-book/screens/upload.dart';
import 'package:gethebooks/authentication/user.dart';
import 'package:gethebooks/app/qna-forum/qnapage.dart';
import 'package:gethebooks/screens/list_book.dart';
import 'package:gethebooks/screens/menu.dart';
import 'package:gethebooks/widgets/navbar.dart';
import 'package:gethebooks/widgets/profile_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String username;
  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Uploadbook> uploadedBooks = [];

  @override
  void initState() {
    super.initState();
    fetchUploadedbooks().then((books) {
      setState(() {
        uploadedBooks = books;
      });
    });
  }

  Future<ProfileData> fetchProfileData(var request) async {
    var profileRaw =
        await request.get("http://127.0.0.1:8000/checkout/get-user/");
    var balanceRaw = await request.get("http://127.0.0.1:8000/get_saldo/");
    var profileData = profileRaw[0]["fields"];
    var balanceData = balanceRaw[0]["fields"];
    return ProfileData(profileData["username"], balanceData["saldo"]);
  }

  Future<List<NotaItem>> fetchNota(var request) async {
    List<NotaItem> orderData = [];
    var notaRaw = await request.get("http://127.0.0.1:8000/checkout/get-nota/");
    for (var nota in notaRaw) {
      var data = nota["fields"];
      orderData.add(NotaItem(
        nota["pk"],
        data["date"],
        data["total_amount"],
        data["total_harga"],
        data["alamat"],
        data["layanan"],
      ));
    }
    return orderData;
  }

  Future<void> uploadBook(Map<String, dynamic> bookData) async {
    final request = context.read<CookieRequest>();
    var response = await request.postJson(
      'http://127.0.0.1:8000/uploadbook/upload-book-json/',
      jsonEncode(bookData),
    );

    if (response["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book uploaded successfully')),
      );

      // Refresh daftar buku setelah upload berhasil
      fetchUploadedbooks().then((updatedBooks) {
        setState(() {
          uploadedBooks = updatedBooks;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload book')),
      );
    }
  }

  void showAddBookBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return AddBookBottomSheet(uploadBook: uploadBook);
      },
    );
  }

  Future<List<Uploadbook>> fetchUploadedbooks() async {
    // Replace with your actual API endpoint
    const url = 'http://127.0.0.1:8000/uploadbook-json/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return uploadbookFromJson(response.body);
    } else {
      throw Exception('Failed to load upload books');
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(username: widget.username)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductPage(username: widget.username)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ForumPage()),
        );
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellow,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onItemTapped: (index) => _onItemTapped(index, context),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: fetchProfileData(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    ProfileData profileData = snapshot.data!;
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.yellow,
                            child: Text(
                              profileData.name.substring(0, 3).toUpperCase(), 
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal ,color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            'Hi! ${user.username}',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          ProfileCard(profileData.name, profileData.balance),
                          ElevatedButton(
                            onPressed: () => showAddBookBottomSheet(context),
                            child: Text('Upload Your Book'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Book",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              FutureBuilder<List<Uploadbook>>(
                future: Future.value(uploadedBooks),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    List<Uploadbook> uploadedBooks = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: uploadedBooks.length,
                      itemBuilder: (context, index) {
                        Fields book = uploadedBooks[index].fields;
                        return Card(
                          elevation: 4.0,
                          margin: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    book.image,
                                    fit: BoxFit.cover,
                                    height: 180.0,
                                    width: 120.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Tampilkan ikon dummy jika gambar gagal dimuat
                                      return const Icon(Icons.book, size: 120.0, color: Colors.grey);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        book.author,
                                        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        "Rp${book.price.toString()}",
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        "Stok: ${book.stocks}",
                                        style: const TextStyle(fontSize: 14.0,),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Riwayat Pemesanan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                height: 240,
                child: FutureBuilder(
                  future: fetchNota(request),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      List<NotaItem> notaItems = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: notaItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NotaCard(
                              notaItems[index],
                              changed: () {
                                setState(() {
                                  notaItems.removeAt(index);
                                });
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
