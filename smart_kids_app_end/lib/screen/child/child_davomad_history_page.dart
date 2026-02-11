import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChildDavomadHistoryPage extends StatefulWidget {
  final int id;

  const ChildDavomadHistoryPage({super.key, required this.id});

  @override
  State<ChildDavomadHistoryPage> createState() =>
      _ChildDavomadHistoryPageState();
}

class _ChildDavomadHistoryPageState extends State<ChildDavomadHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Davomad"),
      ),
    );
  }
}
