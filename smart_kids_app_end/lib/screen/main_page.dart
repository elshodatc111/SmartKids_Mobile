import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_kids_app_end/const/menu_const.dart'; // Menyu listini import qilish
import 'package:smart_kids_app_end/screen/profile/profile_page.dart';
import 'package:smart_kids_app_end/screen/tkun/tugilgan_kun_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final String lang = box.read('lang') ?? 'uz';

    // Foydalanuvchi rolini olish (xavfsizlik uchun kichik harflarda)
    final profile = box.read('profile');
    final String userRole = profile?['type']?.toString().toLowerCase() ?? 'hodim';

    // Foydalanuvchi roliga mos menyularni filtrlash
    final accessibleMenus = MenuConst.items.where((item) {
      final List roles = item['roles'] as List;
      return roles.contains(userRole);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9), // CRM foni
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Smart Kids",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const TugilganKunPage()),
            icon: const Icon(Icons.celebration_outlined, color: Colors.orangeAccent, size: 26),
            tooltip: lang == 'uz' ? "Tug'ilgan kunlar" : 'Дни рождения',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => Get.to(() => const ProfilePage()),
              icon: const Icon(Icons.account_circle, size: 30, color: Colors.blue),
              tooltip: lang == 'uz' ? 'Profil' : 'Профиль',
            ),
          ),
        ],
      ),
      body: accessibleMenus.isEmpty
          ? _buildEmptyState(lang)
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: accessibleMenus.length,
        itemBuilder: (context, index) {
          final item = accessibleMenus[index];
          final Color itemColor = item['color'] as Color;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: itemColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'], color: itemColor, size: 28),
              ),
              title: Text(
                lang == 'uz' ? item['title_uz'] : item['title_ru'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              onTap: () {
                final Widget targetPage = item['page']; // Ro'yxatdagi sahifani olamiz

                if (targetPage is! SizedBox) { // Agar sahifa biriktirilgan bo'lsa
                  Get.to(() => targetPage);
                } else {
                  // Agar hali sahifa tayyor bo'lmasa, ogohlantirish berish mumkin
                  Get.snackbar(
                    lang == 'uz' ? "Tez kunda" : "Скоро",
                    lang == 'uz' ? "Ushbu bo'lim ustida ish olib borilmoqda" : "Этот раздел находится в разработке",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blueGrey,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  // Agar foydalanuvchiga hech qanday menyu ruxsat berilmagan bo'lsa
  Widget _buildEmptyState(String lang) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_person_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            lang == 'uz' ? "Sizda ruxsatlar mavjud emas" : "У вас нет доступа",
            style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}