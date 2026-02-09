import 'package:flutter/material.dart';
class ChildShowPage extends StatefulWidget {
  final int id;
  const ChildShowPage({super.key, required this.id});

  @override
  State<ChildShowPage> createState() => _ChildShowPageState();
}

class _ChildShowPageState extends State<ChildShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${widget.id}"),
      ),
    );
  }
}
