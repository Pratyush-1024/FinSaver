import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/features/notifications/service/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationsScreen extends StatefulWidget {
  final List<Map<String, String>> notifications;

  const NotificationsScreen({super.key, required this.notifications});

  static const routeName = '/notifications';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<Map<String, String>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = widget.notifications;
  }

  void removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(index),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    String? notificationId = notifications[index]['_id'];

                    if (notificationId != null) {
                      NotificationService().deleteNotification(
                        context: context,
                        notificationId: notificationId,
                        onSuccess: () {
                          removeNotification(index);
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notification ID is null or invalid.'),
                        ),
                      );
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.notification_important),
              title: Text(notifications[index]['title'] ?? 'No Title'),
              subtitle: Text(notifications[index]['body'] ?? 'No Body'),
            ),
          );
        },
      ),
    );
  }
}
