import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mishwary/models/transaction.dart'; // استيراد النموذج الذي أنشأناه
// سنقوم بإنشاء هذا الملف في الخطوة التالية
// import 'package:mishwary/screens/home_screen.dart'; 

Future<void> main() async {
  // تأكد من تهيئة Flutter قبل أي شيء
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة قاعدة بيانات Hive
  await Hive.initFlutter();

  // تسجيل النموذج (Adapter) الذي أنشأناه
  // هذا يخبر Hive كيف يقرأ ويكتب بيانات Transaction
  Hive.registerAdapter(TransactionAdapter());

  // فتح "صندوق" لتخزين المعاملات المالية
  await Hive.openBox<Transaction>('transactions');

  // تشغيل التطبيق
  runApp(
    // ProviderScope ضروري لعمل Riverpod
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mishwary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        fontFamily: 'Roboto', // يمكنك تغيير الخط لاحقًا إذا أردت
      ),
      // سنقوم بتغيير هذا لاحقًا إلى شاشتنا الرئيسية الفعلية
      home: Scaffold( 
        appBar: AppBar(
          title: Text('Mishwary - تحت الإنشاء'),
        ),
        body: Center(
          child: Text('تم تهيئة قاعدة البيانات بنجاح!'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
