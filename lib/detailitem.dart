import 'package:Instafood/helpers/GlobalConst.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String subtitle;
  final int rating;

  const DetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.subtitle,
    required this.rating,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool notification = true;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _showNotification(String title, String subtitle) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      subtitle,
      platformChannelSpecifics,
      payload: '',
    );

    setState(() {
      notification = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNotification(widget.title, widget.subtitle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          if (notification)
            Stack(children: <Widget>[
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  _showNotification(widget.title, widget.subtitle);
                },
              ),
              _redDot()
            ]),
          if (!notification)
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                _showNotification(widget.title, widget.subtitle);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.network("${Globalconst.baseUrlApi}/item_images/${widget.imageUrl}"),
                // Image.asset('assets/images/${widget.imageUrl}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (int i = 1; i <= widget.rating; i++)
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                    for (int i = 1; i <= 5 - widget.rating; i++)
                      const Icon(Icons.star_border, color: Colors.yellow, size: 20),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _redDot() {
    return Positioned(
      right: 15,
      top: 12,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(7),
        ),
        constraints: const BoxConstraints(
          minWidth: 10,
          minHeight: 10,
        ),
        child: const SizedBox(
          width: 1,
          height: 1,
        ),
      ),
    );
  }
}
