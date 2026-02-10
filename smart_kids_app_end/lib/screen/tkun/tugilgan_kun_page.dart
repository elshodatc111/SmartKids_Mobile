import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TugilganKunPage extends StatefulWidget {
  const TugilganKunPage({super.key});

  @override
  State<TugilganKunPage> createState() => _TugilganKunPageState();
}

class _TugilganKunPageState extends State<TugilganKunPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false; // API kelganda true qilinadi

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          "Tug'ilgan kunlar",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1E293B)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.indigo,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.indigo,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Xodimlar", icon: Icon(Icons.badge_rounded, size: 20)),
            Tab(text: "Bolalar", icon: Icon(Icons.child_care_rounded, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBirthdaysList("xodim"),
          _buildBirthdaysList("bola"),
        ],
      ),
    );
  }

  Widget _buildBirthdaysList(String type) {
    // Bu yerda API'dan keladigan mock ma'lumotlar
    List mockData = [
      {"name": "Aliyev Vali", "date": "2026-02-15", "age": 25, "days_left": 4, "image": ""},
      {"name": "Sattorova Gulnoza", "date": "2026-02-18", "age": 22, "days_left": 7, "image": ""},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockData.length,
      itemBuilder: (context, index) {
        final item = mockData[index];
        return _birthdayCard(item, type);
      },
    );
  }

  Widget _birthdayCard(Map item, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.indigo.withOpacity(0.1),
              child: const Icon(Icons.person_rounded, color: Colors.indigo),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
              child: const Icon(Icons.cake_rounded, color: Colors.white, size: 12),
            )
          ],
        ),
        title: Text(
          item['name'],
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E293B)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "${item['date']} • ${item['age']} yoshga to'ladi",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: item['days_left'] == 0 ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            item['days_left'] == 0 ? "Bugun" : "${item['days_left']} kun qoldi",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: item['days_left'] == 0 ? Colors.green : Colors.orange.shade800,
            ),
          ),
        ),
      ),
    );
  }
}