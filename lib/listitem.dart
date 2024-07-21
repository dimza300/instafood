import 'package:Instafood/api/ItemServices.dart';
import 'package:Instafood/api/UserServices.dart';
import 'package:Instafood/helpers/GlobalConst.dart';
import 'package:Instafood/login.dart';
import 'package:Instafood/model/Item.dart';
import 'package:flutter/material.dart';
import 'detailitem.dart';
import 'change_password.dart';
// import 'helpers/database_helper.dart'; // Import DetailPage

class ListItemPage extends StatefulWidget {
  const ListItemPage({super.key});

  @override
  _ListItemPageState createState() => _ListItemPageState();
}

class _ListItemPageState extends State<ListItemPage> {
  final UserServices _userServices = UserServices();
  // final DatabaseHelper _databaseHelper = DatabaseHelper();
  final Itemservices _itemservices = Itemservices();
  late Future<ResponseItemModel> _contentList;
  // late Future<List<Map<String, dynamic>>> _contentList;

  Future<String> _getUsername() async {
    try {
      final user = await _userServices.fetchUserData();
      if (user != null) {
        return user.name;
      } else {
        throw Exception("User not found or 'username' key missing");
      }
    } catch (e) {
      return "Error";
    }
  }

  Future<void> _Logout() async {
    await _userServices.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _contentList = _itemservices.getItem();
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
                gradient: LinearGradient(colors: [Colors.deepPurple, Colors.pink])),
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
            // child: FutureBuilder<List<Map<String, dynamic>>>(
            child: FutureBuilder<ResponseItemModel>(
          future: _contentList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              return const Center(child: Text('No content available'));
            } else {
              final List<Item> content = snapshot.data!.data;
              return ListView.builder(
                itemCount: content.length,
                itemBuilder: (context, index) {
                  final item = content[index];
                  return ListTile(
                    leading: Image.network(Globalconst.baseUrlApi + "/item_images/" + item.image),
                    // leading: Image.asset('assets/images/${item.image}'),
                    title: Text(item.itemName),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.itemName),
                      Row(children: [
                        for (int i = 1; i <= item.rating; i++)
                          const Icon(Icons.star, color: Colors.yellow, size: 20),
                        for (int i = 1; i <= 5 - item.rating; i++)
                          const Icon(Icons.star_border, color: Colors.yellow, size: 20),
                      ])
                    ]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                              title: item.itemName,
                              description: item.description,
                              imageUrl: item.image,
                              rating: item.rating,
                              subtitle: item.itemName),
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
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.purple,
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.abc),
          //   label: 'Ext',
          // ),
        ],
        onTap: (index) {
          if (index == 2) {
            _Logout();
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
          // else if (index == 3) {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => OverlappingHeaderScreen()),
          //   );
          // }
        },
      ),
    );
  }
}
