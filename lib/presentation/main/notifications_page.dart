import 'package:flutter/material.dart';
import 'package:mvvm/presentation/resources/strings_manager.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:Text(AppStrings.notifications),
    );
  }
}
