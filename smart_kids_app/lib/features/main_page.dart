import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sss'),
        actions: [

        ],
      ),
    );
  }

}