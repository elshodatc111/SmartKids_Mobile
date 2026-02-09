import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:smart_kids_app_end/const/api_const.dart';
import 'package:smart_kids_app_end/screen/child/child_show_page.dart';

class GroupShowController extends GetxController {
  final int id;

  GroupShowController({required this.id});

  var isLoading = true.obs;
  var isKidsLoading = false.obs;
  var isUsersLoading = false.obs;
  var isUpdating = false.obs;
  var isAddingKid = false.obs;
  var deletingIds = <int>[].obs;
  var addingKidIds = <int>[].obs;
  var groupData = {}.obs;
  var groupKids = <dynamic>[].obs;
  var groupUsers = <dynamic>[].obs;
  var noactiveKids = <dynamic>[].obs;
  var filteredNoactiveKids = <dynamic>[].obs;
  var isNoactiveLoading = false.obs;
  final box = GetStorage();
  final lang = GetStorage().read('lang') ?? 'uz';

  @override
  void onInit() {
    super.onInit();
    fetchGroupDetails();
  }

  Future<void> fetchGroupDetails() async {
    isLoading.value = true;
    String? token = box.read('token');
    try {
      final response = await http.get(
        Uri.parse('${ApiConst.apiUrl}/group/show/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        groupData.value = jsonDecode(response.body)['data'];
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNoactiveKids() async {
    isNoactiveLoading.value = true;
    String? token = box.read('token');
    try {
      final response = await http.get(
        Uri.parse('${ApiConst.apiUrl}/kids/isactive'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        noactiveKids.value = data;
        filteredNoactiveKids.value = data;
      }
    } finally {
      isNoactiveLoading.value = false;
    }
  }

  void searchNoactiveKid(String query) {
    if (query.isEmpty) {
      filteredNoactiveKids.value = noactiveKids;
    } else {
      filteredNoactiveKids.value = noactiveKids
          .where(
            (k) => k['full_name'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  Future<void> addKidToGroup(int kidId) async {
    addingKidIds.add(kidId);
    String? token = box.read('token');
    try {
      final response = await http.post(
        Uri.parse('${ApiConst.apiUrl}/group/add/kids'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"group_id": id, "kids_id": kidId}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isBottomSheetOpen ?? false) Get.back();
        await fetchGroupDetails();
        Get.snackbar(
          lang == 'uz' ? "Muvaffaqiyatli" : "Успешно",
          lang == 'uz' ? "Bola guruhga qo'shildi" : "Ребенок добавлен в группу",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } finally {
      addingKidIds.remove(kidId);
    }
  }

  Future<void> removeFromGroup(int historyId, bool isKid) async {
    deletingIds.add(historyId);
    String? token = box.read('token');
    String endpoint = isKid ? 'delete/kids' : 'delete/user';
    try {
      final response = await http.post(
        Uri.parse('${ApiConst.apiUrl}/group/$endpoint/$historyId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        if (Get.isBottomSheetOpen ?? false) Get.back();
        await fetchGroupDetails();
        if (isKid)
          await fetchGroupKids();
        else
          await fetchGroupUsers();
        Get.snackbar(
          lang == 'uz' ? "Muvaffaqiyatli" : "Успешно",
          lang == 'uz' ? "Guruhdan o'chirildi" : "Удален из группы",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } finally {
      deletingIds.remove(historyId);
    }
  }

  Future<void> updateGroup(String name, String desc, String amount) async {
    isUpdating.value = true;
    String? token = box.read('token');
    try {
      final response = await http.post(
        Uri.parse('${ApiConst.apiUrl}/group/update/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "description": desc,
          "amount": int.parse(amount.replaceAll(RegExp(r'[^0-9]'), '')),
        }),
      );
      if (response.statusCode == 200) {
        Get.back();
        await fetchGroupDetails();
        Get.snackbar(
          lang == 'uz' ? "Muvaffaqiyatli" : "Успешно",
          lang == 'uz' ? "Ma'lumotlar yangilandi" : "Данные обновлены",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> fetchGroupKids() async {
    isKidsLoading.value = true;
    String? token = box.read('token');
    try {
      final response = await http.get(
        Uri.parse('${ApiConst.apiUrl}/group/kids/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200)
        groupKids.value = jsonDecode(response.body)['data'];
    } finally {
      isKidsLoading.value = false;
    }
  }

  Future<void> fetchGroupUsers() async {
    isUsersLoading.value = true;
    String? token = box.read('token');
    try {
      final response = await http.get(
        Uri.parse('${ApiConst.apiUrl}/group/users/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200)
        groupUsers.value = jsonDecode(response.body)['data'];
    } finally {
      isUsersLoading.value = false;
    }
  }
}

class GroupShowPage extends StatelessWidget {
  final int id;

  const GroupShowPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroupShowController(id: id));
    final lang = controller.lang;
    final currencyFormat = NumberFormat("#,###", "uz_UZ");
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          lang == 'uz' ? "Guruh tafsilotlari" : "Детали группы",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.groupData.isEmpty) {
          return const Center(
            child: SpinKitFadingFour(color: Colors.blue, size: 40),
          );
        }
        final d = controller.groupData;
        return RefreshIndicator(
          onRefresh: () => controller.fetchGroupDetails(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMainCard(d, currencyFormat, lang),
                const SizedBox(height: 24),
                _btnAction(
                  Icons.edit_document,
                  lang == 'uz' ? "Guruhni tahrirlash" : "Редактировать группу",
                  Colors.blue,
                  () => _showEditModal(context, controller, lang),
                ),
                _btnAction(
                  Icons.history_edu_rounded,
                  lang == 'uz' ? "Bolalar tarixi" : "История детей",
                  Colors.indigo,
                  () {
                    controller.fetchGroupKids();
                    _showHistoryModal(context, controller, lang, true);
                  },
                ),
                _btnAction(
                  Icons.person_add_alt_1_rounded,
                  lang == 'uz' ? "Guruhga bola qo'shish" : "Добавить ребенка",
                  Colors.orange,
                  () {
                    controller.fetchNoactiveKids();
                    _showAddKidModal(context, controller, lang);
                  },
                ),
                _btnAction(
                  Icons.manage_accounts_rounded,
                  lang == 'uz'
                      ? "Tarbiyachilar tarixi"
                      : "История воспитателей",
                  Colors.teal,
                  () {
                    controller.fetchGroupUsers();
                    _showHistoryModal(context, controller, lang, false);
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMainCard(dynamic d, NumberFormat format, String lang) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.groups_2_rounded,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d['group_name'] ?? '-',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      d['description'] ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          _rowInfo(
            Icons.payments_rounded,
            lang == 'uz' ? "Guruh narxi" : "Стоимость группы",
            "${format.format(d['amount'] ?? 0)} UZS",
            Colors.green,
          ),
          _rowInfo(
            Icons.account_balance_wallet_rounded,
            lang == 'uz' ? "Qarzdorlik" : "Дебет",
            "${d['group_kids_debit'] ?? 0} UZS",
            Colors.red,
          ),
          _rowInfo(
            Icons.person_pin_rounded,
            lang == 'uz' ? "Menejer" : "Менеджер",
            d['admin_name'] ?? '-',
            Colors.orange,
          ),
          _rowInfo(
            Icons.child_care_rounded,
            lang == 'uz' ? "Bolalar" : "Дети",
            "${d['group_kids_count'] ?? 0}",
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _rowInfo(IconData icon, String label, String val, Color col) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: col.withOpacity(0.7)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
          ),
          const Spacer(),
          Text(
            val,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnAction(
    IconData icon,
    String title,
    Color col,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: col.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: col.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: col, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddKidModal(
    BuildContext context,
    GroupShowController controller,
    String lang,
  ) {
    final searchC = TextEditingController();
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 45,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              lang == 'uz'
                  ? "Guruhga bola qo'shish"
                  : "Добавить ребенка в группу",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchC,
                onChanged: controller.searchNoactiveKid,
                decoration: InputDecoration(
                  hintText: lang == 'uz' ? "Qidirish..." : "Поиск...",
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isNoactiveLoading.value)
                  return const Center(
                    child: SpinKitThreeBounce(color: Colors.blue, size: 30),
                  );
                if (controller.filteredNoactiveKids.isEmpty)
                  return Center(
                    child: Text(
                      lang == 'uz'
                          ? "Guruhga biriktirilmagan bolalar mavjud emas."
                          : "В группе нет детей, которые бы в ней не состояли.",
                    ),
                  );
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.filteredNoactiveKids.length,
                  itemBuilder: (context, index) {
                    final kid = controller.filteredNoactiveKids[index];
                    final int kidId = kid['id'];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          kid['full_name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          kid['document_series'] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Obx(
                          () => controller.addingKidIds.contains(kidId)
                              ? const SpinKitRing(
                                  color: Colors.green,
                                  size: 24,
                                  lineWidth: 2,
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_rounded,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  onPressed: () =>
                                      controller.addKidToGroup(kidId),
                                ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditModal(
    BuildContext context,
    GroupShowController controller,
    String lang,
  ) {
    final nameC = TextEditingController(
      text: controller.groupData['group_name'],
    );
    final descC = TextEditingController(
      text: controller.groupData['description'],
    );
    final amountC = TextEditingController(
      text: controller.groupData['amount'].toString(),
    );

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              lang == 'uz' ? "Guruhni tahrirlash" : "Редактировать группу",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _modalInput(
              nameC,
              lang == 'uz' ? "Nomi" : "Название",
              Icons.label_outline_rounded,
            ),
            _modalInput(
              descC,
              lang == 'uz' ? "Tavsif" : "Описание",
              Icons.description_outlined,
              lines: 2,
            ),
            _modalInput(
              amountC,
              lang == 'uz' ? "Narxi" : "Цена",
              Icons.payments_outlined,
              type: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Obx(
              () => controller.isUpdating.value
                  ? const SpinKitThreeBounce(color: Colors.blue, size: 30)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => controller.updateGroup(
                        nameC.text,
                        descC.text,
                        amountC.text,
                      ),
                      child: Text(
                        lang == 'uz' ? "Saqlash" : "Сохранить",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _modalInput(
    TextEditingController c,
    String l,
    IconData i, {
    TextInputType type = TextInputType.text,
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: l,
          prefixIcon: Icon(i, size: 20, color: Colors.blue.shade300),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  void _showHistoryModal(
    BuildContext context,
    GroupShowController controller,
    String lang,
    bool isKids,
  ) {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: Get.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              isKids
                  ? (lang == 'uz' ? "Bolalar tarixi" : "История детей")
                  : (lang == 'uz'
                        ? "Tarbiyachilar tarixi"
                        : "История воспитателей"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Obx(() {
                final list = isKids
                    ? controller.groupKids
                    : controller.groupUsers;
                final loading = isKids
                    ? controller.isKidsLoading.value
                    : controller.isUsersLoading.value;
                if (loading)
                  return const Center(
                    child: SpinKitThreeBounce(color: Colors.blue, size: 30),
                  );
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final bool isActive = item['status'] == 'active';
                    final int historyId = item['id'];
                    final String name = isKids
                        ? item['kid']['name']
                        : item['user']['name'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isActive
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isActive
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                radius: 20,
                                child: Icon(
                                  isKids
                                      ? Icons.person_rounded
                                      : Icons.school_rounded,
                                  size: 20,
                                  color: isActive ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: isKids
                                          ? () {
                                              Get.back();
                                              Get.to(
                                                () => ChildShowPage(
                                                  id: item['kid']['id'],
                                                ),
                                              );
                                            }
                                          : null,
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isKids
                                              ? Colors.blue
                                              : const Color(0xFF1E293B),
                                          decoration: isKids
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    if (isKids && item['payment_month'] != null)
                                      Text(
                                        "${lang == 'uz' ? 'To\'lov oyi' : 'Месяц оплаты'}: ${item['payment_month']}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (isActive)
                                Obx(
                                  () =>
                                      controller.deletingIds.contains(historyId)
                                      ? const SpinKitRing(
                                          color: Colors.redAccent,
                                          size: 20,
                                          lineWidth: 2,
                                        )
                                      : IconButton(
                                          onPressed: () => _confirmDelete(
                                            context,
                                            controller,
                                            historyId,
                                            isKids,
                                            name,
                                            lang,
                                          ),
                                          icon: const Icon(
                                            Icons.logout_rounded,
                                            color: Colors.redAccent,
                                            size: 22,
                                          ),
                                        ),
                                ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                          ),
                          _historyDetail(
                            Icons.login_rounded,
                            lang == 'uz' ? "Qo'shildi" : "Добавлен",
                            item['add_data'],
                            item['add_admin']['name'],
                            Colors.green,
                          ),
                          if (!isActive && item['delete_data'] != null)
                            _historyDetail(
                              Icons.logout_rounded,
                              lang == 'uz' ? "O'chirildi" : "Удален",
                              item['delete_data'],
                              item['delete_admin']?['name'] ?? '',
                              Colors.red,
                            ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    GroupShowController controller,
    int historyId,
    bool isKid,
    String name,
    String lang,
  ) {
    Get.defaultDialog(
      title: lang == 'uz' ? "Tasdiqlash" : "Подтверждение",
      middleText:
          "$name ${lang == 'uz' ? 'guruhdan o\'chirilsinmi?' : 'будет удален из группы?'}",
      textConfirm: lang == 'uz' ? "O'chirish" : "Удалить",
      textCancel: lang == 'uz' ? "Bekor qilish" : "Отмена",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () => controller.removeFromGroup(historyId, isKid),
    );
  }

  Widget _historyDetail(
    IconData icon,
    String label,
    String date,
    String admin,
    Color col,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: col),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $date (Admin: $admin)",
              style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }
}
