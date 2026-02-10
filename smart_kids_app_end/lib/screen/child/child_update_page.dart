import 'package:flutter/material.dart';
class ChildUpdatePage extends StatefulWidget {
  final int id;
  const ChildUpdatePage({super.key, required this.id});

  @override
  State<ChildUpdatePage> createState() => _ChildUpdatePageState();
}

class _ChildUpdatePageState extends State<ChildUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Taxrirlash"),),
    );
  }
}
