import 'package:flutter/material.dart';
import 'package:gethebooks/app/checkout-book/widgets/nota_card.dart';
import 'package:gethebooks/app/qna-forum/qnapage.dart';
import 'package:gethebooks/screens/list_book.dart';
import 'package:gethebooks/screens/menu.dart';
import 'package:gethebooks/widgets/navbar.dart';
import 'package:gethebooks/widgets/profile_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        title: const Text('Pembayaran', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow[700],
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
                          ProfileCard(profileData.name, profileData.balance),
                        ],
                      ),
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
              Container(
                padding: const EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Daftar Buku",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              // Ubah jadi modul upload buku
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
            ],
          ),
        ),
      ),
    );
  }
}
