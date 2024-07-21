import 'package:Instafood/api/UserServices.dart';
import 'package:Instafood/listitem.dart';
import 'package:Instafood/login.dart';
import 'package:Instafood/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final UserServices _userServices = UserServices();
  final _storage = FlutterSecureStorage();
  User? _user;

  @override
  void initState() {
    super.initState();
    _cekSession();
  }

  Future<void> _cekSession() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
      final user = await _userServices.fetchUserData();
      if (user != null) {
        setState(() {
          _user = user;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ListItemPage()),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Check Your Connection",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        Future.delayed(const Duration(seconds: 30)).then((val) {
          _cekSession();
        });
      }
    } on Exception catch (exception) {
      Fluttertoast.showToast(
          msg: exception.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [Colors.purple, Colors.deepPurple, Colors.pink],
            ),
          ),
        ),
        const Center(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("INSTAFOOD",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'BlueVinyl',
                  fontWeight: FontWeight.normal)),
        ))
      ]),
    );
  }
}
