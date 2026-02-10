import 'package:flutter/material.dart';
class ChildHistoryPage extends StatefulWidget {
  final int id;
  const ChildHistoryPage({super.key, required this.id});

  @override
  State<ChildHistoryPage> createState() => _ChildHistoryPageState();
}

class _ChildHistoryPageState extends State<ChildHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bola tarixi"),
      ),
    );
  }
}
