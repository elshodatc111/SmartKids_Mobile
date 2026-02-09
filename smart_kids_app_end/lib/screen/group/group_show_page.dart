import 'package:flutter/material.dart';
class GroupShowPage extends StatefulWidget {
  final int id;
  const GroupShowPage({super.key, required this.id});

  @override
  State<GroupShowPage> createState() => _GroupShowPageState();
}

class _GroupShowPageState extends State<GroupShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${widget.id}"),
      ),
    );
  }
}
