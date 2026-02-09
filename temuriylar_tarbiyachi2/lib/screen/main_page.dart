import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:temuriylar_crm_app_admin/screen/tkun/tkun_page.dart';
import '../../screen/profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, dynamic>? get user {
    final u = box.read('user');
    if (u == null) return null;
    if (u is Map<String, dynamic>) return u;
    return Map<String, dynamic>.from(u);
  }

  @override
  Widget build(BuildContext context) {
    final userMap = user;
    final name = userMap != null ? (userMap['name'] ?? 'Foydalanuvchi') : 'Foydalanuvchi';
    final phone = userMap != null ? (userMap['phone'] ?? '') : '';
    final position = userMap != null ? (userMap['position'] ?? '') : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('TEMURIYLAR'),
        elevation: 2,
        actions: [
          IconButton(
            onPressed: (){Get.to(()=>TkunPage());},
            icon: Icon(Icons.cake_outlined),
          ),
          IconButton(onPressed: (){
            Get.to(()=>ProfilePage());
          }, icon: Icon(Icons.person)),
          SizedBox(width: 4.0,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [


          ],
        ),
      ),
    );
  }
}

