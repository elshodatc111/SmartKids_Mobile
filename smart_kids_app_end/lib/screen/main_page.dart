import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_kids_app_end/screen/profile/profile_page.dart';
import 'package:smart_kids_app_end/screen/tkun/tugilgan_kun_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final lang = box.read('lang') ?? 'uz';

    return Scaffold(
      appBar: AppBar(
        // Sarlavha chap tomonga olinadi (Profil o'ngga o'tganda shunday chiroyli chiqadi)
        centerTitle: false,
        title: const Text(
          "Smart Kids",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        actions: [
          // 1. Tug'ilgan kun tugmasi (Bayramona ikonka bilan)
          IconButton(
            onPressed: () => Get.to(() => const TugilganKunPage()),
            icon: const Icon(
              Icons.celebration_outlined, // Sharlar va bayramona ikonka
              color: Colors.orangeAccent, // Diqqatni tortish uchun iliq rang
              size: 26,
            ),
            tooltip: lang == 'uz' ? "Tug'ilgan kunlar" : 'Дни рождения',
          ),

          // 2. Profil tugmasi (Endi o'ng tomonda)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => Get.to(() => const ProfilePage()),
              icon: const Icon(
                Icons.account_circle, // To'ldirilgan ikonka professional ko'rinadi
                size: 30,
                color: Colors.blue,
              ),
              tooltip: lang == 'uz' ? 'Profil' : 'Профиль',
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dashboard (Asosiy qism) uchun joy
            Icon(Icons.dashboard_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              lang == 'uz' ? "Asosiy sahifa" : "Главная страница",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}