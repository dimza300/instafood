import 'package:flutter/material.dart';
import 'detailitem.dart';
import 'change_password.dart';
import 'main.dart';
import 'helpers/database_helper.dart'; // Import DetailPage

class ListItemPage extends StatefulWidget {
  const ListItemPage({super.key});

  @override
  _ListItemPageState createState() => _ListItemPageState();
}

class _ListItemPageState extends State<ListItemPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _contentList;

  Future<String> _getUsername() async {
    try {
      var user = await _databaseHelper.getUserActive();
      if (user != null && user.containsKey("username")) {
        return user["username"];
      } else {
        throw Exception("User not found or 'username' key missing");
      }
    } catch (e) {
      return "Error";
    }
  }

  @override
  void initState() {
    super.initState();
    _contentList = _databaseHelper.getContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
            ),
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
                  alignment: Alignment.topLeft,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    FutureBuilder<String>(
                        future: _getUsername(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              "Hello ${snapshot.data},",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          } else {
                            return const Text("Hmm");
                          }
                        }),
                    const SizedBox(height: 5),
                    const Text(
                      'Makanan Khas Purwakarta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ]))
            ])),
        Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _contentList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No content available'));
            } else {
              final List<Map<String, dynamic>> content = snapshot.data!;
              return ListView.builder(
                itemCount: content.length,
                itemBuilder: (context, index) {
                  final item = content[index];
                  return ListTile(
                    leading: Image.asset('assets/images/' + item['file_image']),
                    title: Text(item['title']),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item['subtitle']),
                      Row(children: [
                        for (int i = 1; i <= item['rating']; i++)
                          const Icon(Icons.star, color: Colors.yellow, size: 20),
                        for (int i = 1; i <= 5 - item['rating']; i++)
                          const Icon(Icons.star_border, color: Colors.yellow, size: 20),
                      ])
                    ]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                              title: item['title'],
                              description: item['description'],
                              imageUrl: item['file_image'],
                              rating: item['rating'],
                              subtitle: item['subtitle']),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        )),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.key),
            label: 'Change Password',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Logout',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.purple,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
            );
          } else if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ListItemPage()),
            );
          }
        },
      ),
    );
  }
}
