import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class KassaPeddingPayment extends StatefulWidget {
  const KassaPeddingPayment({super.key});

  @override
  State<KassaPeddingPayment> createState() => _KassaPeddingPaymentState();
}

class _KassaPeddingPaymentState extends State<KassaPeddingPayment> {
  @override
  final lang = GetStorage().read('lang') ?? 'uz';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang == 'uz'
              ? "Tasdiqlanmagan to\lovlar"
              : "Неподтвержденные платежи",
        ),
      ),
    );
  }
}
